// To parse this JSON data, do
//
//     final empleadoModel = empleadoModelFromJson(jsonString);

import 'dart:convert';

EmpleadoModel empleadoModelFromJson(String str) => EmpleadoModel.fromJson(json.decode(str));

String empleadoModelToJson(EmpleadoModel data) => json.encode(data.toJson());

class EmpleadoModel {
    EmpleadoModel({
        this.ci,
        this.nombre,
        this.apellidoP,
        this.apellidoM,
        this.direccion,
        this.telefono,
        this.fechaNacimiento,
        this.fechaRegistro,
        this.foto,
        this.longitud,
        this.latitud,
        this.calificacionPromedio,
        this.fotoCi,
        this.fotoAntecedentesPenales,
        this.fotoSelfieCi,
        this.tipo = 'empleado',
        this.estado = 'activo',
        this.sancion = 'inactivo',
        this.estadoRegistro = 'espera',
        this.id,
    });

    int ci;
    String nombre;
    String apellidoP;
    String apellidoM;
    String direccion;
    int telefono;
    String fechaNacimiento;
    String fechaRegistro;
    String foto;
    double longitud;
    double latitud;
    double calificacionPromedio;
    String fotoCi;
    String fotoAntecedentesPenales;
    String fotoSelfieCi;
    String tipo;
    String estado;
    String sancion;
    String estadoRegistro;
    int id;

    factory EmpleadoModel.fromJson(Map<String, dynamic> json) => EmpleadoModel(
        ci: json["ci"],
        nombre: json["nombre"],
        apellidoP: json["apellidoP"],
        apellidoM: json["apellidoM"],
        direccion: json["direccion"],
        telefono: json["telefono"],
        fechaNacimiento: json["fechaNacimiento"],
        fechaRegistro: json["fechaRegistro"],
        foto: json["foto"],
        // longitud: json["longitud"].toDouble(),
        // latitud: json["latitud"].toDouble(),
        //calificacionPromedio: json["calificacionPromedio"].toDouble(),
        fotoCi: json["fotoCi"],
        fotoAntecedentesPenales: json["fotoAntecedentesPenales"],
        fotoSelfieCi: json["fotoSelfieCi"],
        tipo: json["tipo"],
        estado: json["estado"],
        sancion: json["sancion"],
        estadoRegistro: json["estadoRegistro"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "ci": ci,
        "nombre": nombre,
        "apellidoP": apellidoP,
        "apellidoM": apellidoM,
        "direccion": direccion,
        "telefono": telefono,
        "fechaNacimiento": fechaNacimiento,
        "fechaRegistro": fechaRegistro,
        "foto": foto,
        "longitud": longitud,
        "latitud": latitud,
        "calificacionPromedio": calificacionPromedio,
        "fotoCi": fotoCi,
        "fotoAntecedentesPenales": fotoAntecedentesPenales,
        "fotoSelfieCi": fotoSelfieCi,
        "tipo": tipo,
        "estado": estado,
        "sancion": sancion,
        "estadoRegistro": estadoRegistro,
        "id": id,
    };
}
