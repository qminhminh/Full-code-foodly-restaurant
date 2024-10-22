import 'dart:convert';

VoucherModel voucherModelFromJson(String str) =>
    VoucherModel.fromJson(json.decode(str));

String voucherModelToJson(VoucherModel data) => json.encode(data.toJson());

class VoucherModel {
  final String title;
  final String description;
  final int discount;
  final bool addVoucherSwitch; // Use this consistently for the switch field
  final String restaurant;

  VoucherModel({
    required this.title,
    required this.description,
    required this.discount,
    required this.addVoucherSwitch, // Ensure you're using this name
    required this.restaurant,
  });

  factory VoucherModel.fromJson(Map<String, dynamic> json) => VoucherModel(
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
