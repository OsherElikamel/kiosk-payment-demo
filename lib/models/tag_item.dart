class TagItem {
  final String tagId;
  final String assetPath;
  final double price;
  final String name;

  TagItem({
    required this.tagId,
    required this.assetPath,
    required this.price,
    required this.name,
  });

  factory TagItem.fromMap(Map<String, dynamic> m) {
    return TagItem(
      tagId: m['tagId'] as String,
      assetPath: m['asset'] as String,
      price: (m['price'] as num).toDouble(),
      name: m['name'] as String,
    );
  }
}
