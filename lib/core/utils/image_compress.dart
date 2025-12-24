import 'dart:typed_data';

import 'package:image/image.dart' as img;

class CompressedImage {
  CompressedImage({
    required this.bytes,
    required this.mimeType,
    required this.filename,
  });

  final Uint8List bytes;
  final String mimeType;
  final String filename;
}

/// Best-effort compression for upload (resizes and encodes as JPEG).
CompressedImage compressForUpload(
  Uint8List originalBytes, {
  int maxDimension = 1280,
  int jpegQuality = 82,
  String filenameBase = 'image',
}) {
  try {
    final decoded = img.decodeImage(originalBytes);
    if (decoded == null) {
      return CompressedImage(
        bytes: originalBytes,
        mimeType: 'application/octet-stream',
        filename: '$filenameBase.bin',
      );
    }

    final width = decoded.width;
    final height = decoded.height;
    final maxSide = width > height ? width : height;
    final needsResize = maxSide > maxDimension;

    final processed = needsResize
        ? img.copyResize(
            decoded,
            width: width >= height ? maxDimension : null,
            height: height > width ? maxDimension : null,
            interpolation: img.Interpolation.average,
          )
        : decoded;

    final jpg = img.encodeJpg(processed, quality: jpegQuality);
    return CompressedImage(
      bytes: Uint8List.fromList(jpg),
      mimeType: 'image/jpeg',
      filename: '$filenameBase.jpg',
    );
  } catch (_) {
    return CompressedImage(
      bytes: originalBytes,
      mimeType: 'application/octet-stream',
      filename: '$filenameBase.bin',
    );
  }
}
