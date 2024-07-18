import 'dart:convert';

List<Categories> categoriesFromJson(String str) => List<Categories>.from(json.decode(str).map((x) => Categories.fromJson(x)));
class Categories {
    final String id;
    final String title;
    final String value;
    final String imageUrl;

    Categories({
        required this.id,
        required this.title,
        required this.value,
        required this.imageUrl,
    });

    factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        id: json["_id"],
        title: json["title"],
        value: json["value"],
        imageUrl: json["imageUrl"],
    );
}
