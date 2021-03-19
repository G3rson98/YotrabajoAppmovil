// To parse this JSON data, do
//
//     final horarioModel = horarioModelFromJson(jsonString);

import 'dart:convert';

HorarioModel horarioModelFromJson(String str) => HorarioModel.fromJson(json.decode(str));

String horarioModelToJson(HorarioModel data) => json.encode(data.toJson());

class HorarioModel {
    HorarioModel({
        this.idPersona,
        this.idOficio,
        this.dias,
        this.horaInicio,
        this.horaFin,
    });
    
    int idPersona;
    int idOficio;
    String dias;
    String horaInicio;
    String horaFin;
    
    factory HorarioModel.fromJson(Map<String, dynamic> json) => HorarioModel(
        idPersona: json["idPersona"],
        idOficio: json["idOficio"],
        dias: json["dias"],
        horaInicio: json["horaInicio"],
        horaFin: json["horaFin"],
    );

    Map<String, dynamic> toJson() => {
        "idPersona": idPersona,
        "idOficio": idOficio,
        "dias": dias,
        "horaInicio": horaInicio,
        "horaFin": horaFin,
    };
}
