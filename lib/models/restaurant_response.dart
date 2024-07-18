// To parse this JSON data, do
//
//     final restaurantResponse = restaurantResponseFromJson(jsonString);

import 'dart:convert';

RestaurantResponse restaurantResponseFromJson(String str) => RestaurantResponse.fromJson(json.decode(str));

String restaurantResponseToJson(RestaurantResponse data) => json.encode(data.toJson());

class RestaurantResponse {
    final Coords coords;
    final String id;
    final String title;
    final String time;
    final String imageUrl;
    final List<dynamic> foods;
    final bool pickup;
    final bool delivery;
    final String owner;
    final bool isAvailable;
    final String code;
    final String logoUrl;
    final int rating;
    final String ratingCount;
    final String verification;
    final String verificationMessage;

    RestaurantResponse({
        required this.coords,
        required this.id,
        required this.title,
        required this.time,
        required this.imageUrl,
        required this.foods,
        required this.pickup,
        required this.delivery,
        required this.owner,
        required this.isAvailable,
        required this.code,
        required this.logoUrl,
        required this.rating,
        required this.ratingCount,
        required this.verification,
        required this.verificationMessage,
    });

    factory RestaurantResponse.fromJson(Map<String, dynamic> json) => RestaurantResponse(
        coords: Coords.fromJson(json["coords"]),
        id: json["_id"],
        title: json["title"],
        time: json["time"],
        imageUrl: json["imageUrl"],
        foods: List<dynamic>.from(json["foods"].map((x) => x)),
        pickup: json["pickup"],
        delivery: json["delivery"],
        owner: json["owner"],
        isAvailable: json["isAvailable"],
        code: json["code"],
        logoUrl: json["logoUrl"],
        rating: json["rating"],
        ratingCount: json["ratingCount"],
        verification: json["verification"],
        verificationMessage: json["verificationMessage"],
    );

    Map<String, dynamic> toJson() => {
        "coords": coords.toJson(),
        "_id": id,
        "title": title,
        "time": time,
        "imageUrl": imageUrl,
        "foods": List<dynamic>.from(foods.map((x) => x)),
        "pickup": pickup,
        "delivery": delivery,
        "owner": owner,
        "isAvailable": isAvailable,
        "code": code,
        "logoUrl": logoUrl,
        "rating": rating,
        "ratingCount": ratingCount,
        "verification": verification,
        "verificationMessage": verificationMessage,
    };
}

class Coords {
    final String id;
    final double latitude;
    final double longitude;
    final String address;
    final String title;
    final double latitudeDelta;
    final double longitudeDelta;

    Coords({
        required this.id,
        required this.latitude,
        required this.longitude,
        required this.address,
        required this.title,
        required this.latitudeDelta,
        required this.longitudeDelta,
    });

    factory Coords.fromJson(Map<String, dynamic> json) => Coords(
        id: json["id"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        address: json["address"],
        title: json["title"],
        latitudeDelta: json["latitudeDelta"]?.toDouble(),
        longitudeDelta: json["longitudeDelta"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "title": title,
        "latitudeDelta": latitudeDelta,
        "longitudeDelta": longitudeDelta,
    };
}
