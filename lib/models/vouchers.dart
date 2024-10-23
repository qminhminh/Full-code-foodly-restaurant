import 'dart:convert';

List<Voucher> voucherFromJson(String str) =>
    List<Voucher>.from(json.decode(str).map((x) => Voucher.fromJson(x)));

class Voucher {
  final String id;
  final String title;
  final String description;
  final int discount;
  final bool addVoucherSwitch; // Use this consistently for the switch field
  final String restaurant;

  Voucher({
    required this.id,
    required this.title,
    required this.description,
    required this.discount,
    required this.addVoucherSwitch, // Ensure you're using this name
    required this.restaurant,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) => Voucher(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        discount: json["discount"],
        addVoucherSwitch: json[
            "addVoucherSwitch"], // Match the field name with what you use in the constructor
        restaurant: json["restaurant"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "discount": discount,
        "addVoucherSwitch": addVoucherSwitch, // Consistency here too
        "restaurant": restaurant,
      };
}
