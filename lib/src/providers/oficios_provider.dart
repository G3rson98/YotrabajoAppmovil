import 'dart:convert';
import 'package:http/http.dart' as http;


import 'package:yotrabajo2/src/models/oficio_model.dart';
import 'package:yotrabajo2/environment.dart' as env;

class OficiosProvider {


  final String _url = env.API_URL+'/api/oficio';
  

  Future<List<OficioModel>> cargarOficios() async{
    final url ='$_url/index';
    final resp = await http.get(url);
    final List decodedData = json.decode(resp.body);
    final List<OficioModel> oficios = [];
    if ( decodedData == null) return [];
    decodedData.forEach((element) {
      final oficioTemp = OficioModel.fromJson(element);
      oficios.add(oficioTemp);
    });
    return oficios;
  }

  Future<List<OficioModel>> cargarOficiosEmpleado(int id) async{
    final url ='$_url/obtener/$id';
    final resp = await http.get(url);
    final List decodedData = json.decode(resp.body);
    final List<OficioModel> oficios = [];
    if ( decodedData == null) return [];
    decodedData.forEach((element) {
      final oficioTemp = OficioModel.fromJson(element);
      oficios.add(oficioTemp);
    });
    return oficios;
  }

}