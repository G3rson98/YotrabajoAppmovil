// To parse this JSON data, do
//
//     final oficioModel = oficioModelFromJson(jsonString);

import 'dart:convert';

OficioModel oficioModelFromJson(String str) =>
    OficioModel.fromJson(json.decode(str));

String oficioModelToJson(OficioModel data) => json.encode(data.toJson());

class OficioModel {
  OficioModel({
    this.id,
    this.nombre,
  });

  int id;
  String nombre;

  factory OficioModel.fromJson(Map<String, dynamic> json) => OficioModel(
        id: json["id"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
      };
}
