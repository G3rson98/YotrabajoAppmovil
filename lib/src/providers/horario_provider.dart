import 'dart:convert';


import 'package:http/http.dart' as http;

import 'package:yotrabajo2/src/models/horario_model.dart';

import 'package:yotrabajo2/environment.dart' as env;

class HorarioProvider{

    final String _url = env.API_URL;

    Future<bool> crearHorario(List<HorarioModel> horario,int idPersona) async{

    final url = '$_url/api/horario/registrar';
    Map <String,String> head= {
      "Content-Type":"application/json",
    };

    Map <String,dynamic> body= {
      "horarios":horario,
      "idPersona":idPersona
    };
    final resp = await http.post(url,headers: head ,body: jsonEncode(body));
    final decodedData = json.decode(resp.body);
    print(decodedData);
    return true;
    }
}