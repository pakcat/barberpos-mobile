class AppDimens {
  const AppDimens._();

  // Base unit
  static const double unit = 4;

  // Size scale (in px)
  static const double sizeNone = 0;
  static const double size25 = 1;
  static const double size50 = 2;
  static const double size100 = 4;
  static const double size150 = 6;
  static const double size200 = 8;
  static const double size300 = 12;
  static const double size400 = 16;
  static const double size500 = 20;
  static const double size600 = 24;
  static const double size700 = 28;
  static const double size800 = 32;
  static const double size900 = 36;
  static const double size1000 = 40;
  static const double size1100 = 44;
  static const double size1200 = 48;
  static const double size1300 = 52;

  // Spacing tokens
  static const double spacingXs = 2; // alias 2px
  static const double spacingSm = 4; // alias 4px
  static const double spacingMd = 8; // alias 8px
  static const double spacingLg = 12; // alias 12px
  static const double spacingXl = 16; // alias 16px
  static const double spacingXxl = 20; // alias 20px
  static const double spacingXxxl = 24; // alias 24px

  // Backwards-compatible semantic tokens
  static const double padding = spacingXl;
  static const double spacing = spacingLg;
  static const double cornerRadius = size300;
  static const double cornerRadiusXl = size600;
  static const double buttonHeight = size1200;

  // Breakpoints
  static const double tabletBreakpoint = 900.0;
}
