// To parse this JSON data, do
//
//     final trabajoModel = trabajoModelFromJson(jsonString);

import 'dart:convert';

TrabajoModel trabajoModelFromJson(String str) => TrabajoModel.fromJson(json.decode(str));

String trabajoModelToJson(TrabajoModel data) => json.encode(data.toJson());

class TrabajoModel {
    TrabajoModel({
        this.id,
        this.direccion,
        this.horario,
        this.idContratante,
        this.idEmpleado,
        this.precio,
        this.detalle,
    });

    int id;
    String direccion;
    String horario;
    int idContratante;
    int idEmpleado;
    double precio;
    List<Detalle> detalle;

    factory TrabajoModel.fromJson(Map<String, dynamic> json) => TrabajoModel(
        id: json["id"],
        direccion: json["direccion"],
        horario: json["horario"],
        idContratante: json["idContratante"],
        idEmpleado: json["idEmpleado"],
        precio: json["precio"].toDouble(),
        detalle: List<Detalle>.from(json["detalle"].map((x) => Detalle.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "direccion": direccion,
        "horario": horario,
        "idContratante": idContratante,
        "idEmpleado": idEmpleado,
        "precio": precio,
        "detalle": List<dynamic>.from(detalle.map((x) => x.toJson())),
    };
}

class Detalle {
    Detalle({
        this.nombredetalle,
        this.encargo,
    });

    String nombredetalle;
    String encargo;

    factory Detalle.fromJson(Map<String, dynamic> json) => Detalle(
        nombredetalle: json["nombredetalle"],
        encargo: json["encargo"],
    );

    Map<String, dynamic> toJson() => {
        "nombredetalle": nombredetalle,
        "encargo": encargo,
    };
}
