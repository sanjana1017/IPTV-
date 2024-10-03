import 'dart:convert';

class TvRouteModel {
  // String id;
  String name;
  String logo;
  String link;
  String category;
  // DateTime createdAt;
  // DateTime updatedAt;
  // int v;
  String logoLocalPath;

  TvRouteModel({
    // required this.id,
    required this.name,
    required this.logo,
    required this.link,
    required this.category,
    // required this.createdAt,
    // required this.updatedAt,
    // required this.v,
    this.logoLocalPath = '',
  });

  factory TvRouteModel.fromRawJson(String str) =>
      TvRouteModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TvRouteModel.fromJson(Map<String, dynamic> json) => TvRouteModel(
        // id: json["_id"],
        name: json["name"],
        logo: json["logo"],
        link: json["link"],
        category: json["category"] ?? 'Others', // Default category if not provided
        // createdAt: DateTime.parse(json["createdAt"]),
        // updatedAt: DateTime.parse(json["updatedAt"]),
        // v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        // "_id": id,
        "name": name,
        "logo": logo,
        "link": link,
        "category": category,
        // "createdAt": createdAt.toIso8601String(),
        // "updatedAt": updatedAt.toIso8601String(),
        // "__v": v,
      };
}
