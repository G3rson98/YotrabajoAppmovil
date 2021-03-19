import 'dart:convert';


import 'package:http/http.dart' as http;

import 'package:yotrabajo2/src/models/horario_model.dart';

import 'package:yotrabajo2/environment.dart' as env;
import 'package:yotrabajo2/src/models/oficio_model.dart';
import 'package:yotrabajo2/src/models/trabajo_model.dart';

class TrabajoProvider{

    final String _url = env.API_URL;

    Future<bool> crearTrabajo(TrabajoModel trabajo) async{

    final url = '$_url/api/trabajo/registrar';
    Map <String,String> head= {
      "Content-Type":"application/json",
    };

    // Map <String,dynamic> body= {
    //   "oficios":oficios,
    //   "idPersona":idPersona
    // };
    final resp = await http.post(url,headers: head ,body: trabajoModelToJson(trabajo));
    final decodedData = json.decode(resp.body);
    print(decodedData);
    return true;
    }
}