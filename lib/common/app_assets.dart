class AppAssets {
  static const String logoPath = 'assets/images/paytag_logo.png';

  static String imagePath(String imageFile) => 'assets/images/$imageFile';

  static const List<String> tagInputFiles = [
    'assets/tag_inputs/tag_input_1.xlsx',
    'assets/tag_inputs/tag_input_2.xlsx',
    'assets/tag_inputs/tag_input_3.xlsx',
    'assets/tag_inputs/tag_input_4.xlsx',
  ];

  static const String dbPath = 'assets/tag_data_local.xlsx';
  static const String storesPath = 'assets/stores.json';
  static const String flagIl = 'assets/flags/il.png';
  static const String flagGb = 'assets/flags/gb.png';
}
