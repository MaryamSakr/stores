
class Store {
  final String name;
  final String imageUrl;
  final double x;
  final double y;
  bool isFavorited; // Add the isFavorited property

  Store({
    required this.name,
    required this.imageUrl,
    required this.x,
    required this.y,
    this.isFavorited = false, // Set the default value to false
  });
}
