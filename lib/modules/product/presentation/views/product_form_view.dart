import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/utils/image_compress.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_input_field.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/utils/resolve_image_url.dart';
import '../../../../core/widgets/app_image.dart';
import '../controllers/product_controller.dart';
import '../models/product_models.dart';

class ProductFormView extends StatefulWidget {
  const ProductFormView({super.key});

  @override
  State<ProductFormView> createState() => _ProductFormViewState();
}

class _ProductFormViewState extends State<ProductFormView> {
  final ProductController controller = Get.find<ProductController>();

  bool stockTab = false;
  bool trackStock = false;

  Uint8List? pickedImageBytes;
  String? pickedImageFilename;
  String? pickedImageMimeType;

  late final TextEditingController nameController;
  late final TextEditingController priceController;
  late final TextEditingController descriptionController;
  late final TextEditingController stockController;
  late final TextEditingController minStockController;
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    final id = Get.arguments as String?;
    final existing = id != null ? controller.getById(id) : null;
    trackStock = existing?.trackStock ?? false;
    nameController = TextEditingController(text: existing?.name ?? '');
    priceController = TextEditingController(
      text: existing != null ? '${existing.price}' : '',
    );
    selectedCategory = (existing?.category ?? '').trim();
    if (selectedCategory.isEmpty) selectedCategory = 'Lainnya';
    descriptionController = TextEditingController();
    stockController = TextEditingController(
      text: existing != null ? '${existing.stock}' : '',
    );
    minStockController = TextEditingController(
      text: existing != null ? '${existing.minStock}' : '',
    );
  }

  void save() {
    final id = Get.arguments as String?;
    final name = nameController.text.trim();
    final price = int.tryParse(priceController.text.trim()) ?? 0;
    if (name.isEmpty || price <= 0) return;
    final existing = id != null ? controller.getById(id) : null;
    final category = selectedCategory.trim().isEmpty
        ? 'Lainnya'
        : selectedCategory.trim();
    final product = ProductItem(
      // Use negative numeric IDs for local temp entities so REST create doesn't accidentally send an "id" (update).
      id: id ?? (-DateTime.now().microsecondsSinceEpoch).toString(),
      name: name,
      category: category,
      price: price,
      image: existing?.image ?? '',
      trackStock: trackStock,
      stock: trackStock ? int.tryParse(stockController.text) ?? 0 : 0,
      minStock: trackStock ? int.tryParse(minStockController.text) ?? 0 : 0,
    );
    controller.upsert(
      product,
      imageBytes: pickedImageBytes,
      imageFilename: pickedImageFilename,
      imageMimeType: pickedImageMimeType,
    );
    Get.back();
  }

  Future<void> _pickProductImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (file == null) return;
    final original = await file.readAsBytes();
    if (original.isEmpty) return;
    final compressed = compressForUpload(
      original,
      filenameBase: 'product_${DateTime.now().millisecondsSinceEpoch}',
    );
    setState(() {
      pickedImageBytes = compressed.bytes;
      pickedImageFilename = compressed.filename;
      pickedImageMimeType = compressed.mimeType;
    });
  }

  @override
  Widget build(BuildContext context) {
    final id = Get.arguments as String?;
    final isEdit = id != null;
    return AppScaffold(
      title: isEdit ? 'Ubah Produk' : 'Tambah Produk',
      onNavigateBack: () async => _confirmDiscard(),
      backgroundColor: AppColors.grey900,
      appBarBackgroundColor: Colors.transparent,
      appBarForegroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Tabs(
            activeStock: stockTab,
            onTapInfo: () => setState(() => stockTab = false),
            onTapStock: () => setState(() => stockTab = true),
          ),
          const SizedBox(height: AppDimens.spacingLg),
          Expanded(
            child: SingleChildScrollView(
              child: stockTab ? _stockTab() : _infoTab(),
            ),
          ),
          const SizedBox(height: AppDimens.spacingSm),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange500,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimens.spacingMd,
                ),
              ),
              child: const Text('Simpan'),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmDiscard() async {
    final dirty =
        nameController.text.trim().isNotEmpty ||
        priceController.text.trim().isNotEmpty ||
        selectedCategory.trim().isNotEmpty ||
        descriptionController.text.trim().isNotEmpty ||
        stockController.text.trim().isNotEmpty ||
        minStockController.text.trim().isNotEmpty ||
        trackStock;
    if (!dirty) return true;
    final result = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AppColors.grey800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        ),
        title: const Text(
          'Batalkan perubahan?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Perubahan belum disimpan. Yakin kembali?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Lanjutkan'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Buang'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Widget _infoTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detail Produk',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppDimens.spacingLg),
        const Text('Nama Produk *', style: TextStyle(color: Colors.white70)),
        const SizedBox(height: AppDimens.spacingXs),
        AppInputField(hint: 'Masukkan nama produk', controller: nameController),
        const SizedBox(height: AppDimens.spacingMd),
        const Text('Harga Jual *', style: TextStyle(color: Colors.white70)),
        const SizedBox(height: AppDimens.spacingXs),
        AppInputField(
          hint: 'Masukkan harga jual',
          keyboardType: TextInputType.number,
          controller: priceController,
        ),
        const SizedBox(height: AppDimens.spacingMd),
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          collapsedIconColor: Colors.white,
          iconColor: Colors.white,
          title: const Text(
            'Detail Tambahan (Opsional)',
            style: TextStyle(color: Colors.white),
          ),
          children: [
            const SizedBox(height: AppDimens.spacingSm),
            AppCard(
              backgroundColor: AppColors.grey800,
              borderColor: AppColors.grey700,
              padding: const EdgeInsets.all(AppDimens.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Builder(
                    builder: (context) {
                      final id = Get.arguments as String?;
                      final existing = id != null
                          ? controller.getById(id)
                          : null;
                      final bytes = pickedImageBytes;
                      final imageUrl = existing?.image ?? '';
                      if (bytes != null) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppDimens.cornerRadius,
                          ),
                          child: Image.memory(
                            bytes,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                      if (imageUrl.isNotEmpty) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppDimens.cornerRadius,
                          ),
                          child: AppImage(
                            imageUrl: resolveImageUrl(imageUrl),
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            borderRadius: 0,
                          ),
                        );
                      }
                      return const Icon(
                        Icons.image_outlined,
                        color: AppColors.orange500,
                        size: 48,
                      );
                    },
                  ),
                  const SizedBox(height: AppDimens.spacingSm),
                  const Text(
                    'Tambahkan Foto\nJPG/PNG, max Size 2MB',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: AppDimens.spacingSm),
                  OutlinedButton(
                    onPressed: _pickProductImage,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.orange500),
                      foregroundColor: AppColors.orange500,
                    ),
                    child: const Text('Pilih Foto'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.spacingMd),
            const Text('Kategori', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: AppDimens.spacingXs),
            Obx(() {
              final cats = controller.categories.toList();
              if (selectedCategory.isNotEmpty &&
                  selectedCategory != 'Lainnya' &&
                  !cats.contains(selectedCategory)) {
                cats.insert(0, selectedCategory);
              }
              if (!cats.contains('Lainnya')) cats.add('Lainnya');
              cats.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

              final items = [
                ...cats.map((c) => DropdownMenuItem(value: c, child: Text(c))),
                const DropdownMenuItem(
                  value: '__custom__',
                  child: Text('Kategori baru...'),
                ),
              ];
              return DropdownButtonFormField<String>(
                key: ValueKey<String>('category:$selectedCategory'),
                initialValue: cats.contains(selectedCategory)
                    ? selectedCategory
                    : 'Lainnya',
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: AppColors.grey800,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.grey700),
                  ),
                  labelText: 'Pilih Kategori',
                ),
                dropdownColor: AppColors.grey800,
                items: items,
                onChanged: (v) async {
                  if (v == null) return;
                  if (v != '__custom__') {
                    setState(() => selectedCategory = v);
                    return;
                  }

                  final ctrl = TextEditingController();
                  final result = await Get.dialog<String>(
                    AlertDialog(
                      backgroundColor: AppColors.grey800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimens.cornerRadius,
                        ),
                      ),
                      title: const Text(
                        'Kategori baru',
                        style: TextStyle(color: Colors.white),
                      ),
                      content: TextField(
                        controller: ctrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Nama kategori',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(result: ''),
                          child: const Text('Batal'),
                        ),
                        ElevatedButton(
                          onPressed: () => Get.back(result: ctrl.text.trim()),
                          child: const Text('Simpan'),
                        ),
                      ],
                    ),
                  );

                  final next = (result ?? '').trim();
                  setState(
                    () => selectedCategory = next.isEmpty ? 'Lainnya' : next,
                  );
                },
              );
            }),
            const SizedBox(height: AppDimens.spacingMd),
            const Text(
              'Deskripsi Produk',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: AppDimens.spacingXs),
            AppInputField(
              hint: 'Masukkan deskripsi',
              controller: descriptionController,
              maxLines: 3,
            ),
          ],
        ),
      ],
    );
  }

  Widget _stockTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Stok Produk',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppDimens.spacingXs),
                  Text(
                    'Lacak pengurangan dan penambahan stok produk ini',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            Switch(
              value: trackStock,
              activeTrackColor: AppColors.orange500,
              thumbColor: WidgetStateProperty.all(Colors.black),
              onChanged: (val) => setState(() => trackStock = val),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spacingLg),
        if (trackStock) ...[
          const Text(
            'Jumlah Stok Saat ini *',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: AppDimens.spacingXs),
          AppInputField(
            hint: 'Masukkan stok awal',
            keyboardType: TextInputType.number,
            controller: stockController,
          ),
          const SizedBox(height: AppDimens.spacingMd),
          const Text('Minimal Stok *', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: AppDimens.spacingXs),
          AppInputField(
            hint: 'Masukkan minimal stok',
            keyboardType: TextInputType.number,
            controller: minStockController,
          ),
        ],
      ],
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({
    required this.activeStock,
    required this.onTapInfo,
    required this.onTapStock,
  });

  final bool activeStock;
  final VoidCallback onTapInfo;
  final VoidCallback onTapStock;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey800,
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        border: Border.all(color: AppColors.grey700),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label: 'Informasi Produk',
              active: !activeStock,
              onTap: onTapInfo,
            ),
          ),
          Expanded(
            child: _TabButton(
              label: 'Manajemen Stok',
              active: activeStock,
              onTap: onTapStock,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.spacingMd),
        decoration: BoxDecoration(
          color: active ? AppColors.orange500 : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.black : Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
