import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:mime_type/mime_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yotrabajo2/src/models/empleado_model.dart';
import 'package:yotrabajo2/environment.dart' as env;


class EmpleadosProvider {
  final String _url = env.API_URL;

  Future<int> crearEmpleado(EmpleadoModel empleado) async {
    final url = '$_url/api/empleado/registrar';
    Map<String, String> head = {
      "Content-Type": "application/json",
      "Accept-Encoding": "gzip, json, br",
      "authorization": ""
    };
    final resp = await http.post(url,
        headers: head, body: empleadoModelToJson(empleado));
    final decodedData = json.decode(resp.body);
    print(decodedData);
    return decodedData["id"];
  }


  Future<int> cargarFotos(File imagenCi, File imagenAntecedentes, File selfie,EmpleadoModel empleado) async {

    final url = Uri.parse('$_url/api/empleado/cargarfoto');

    final mimeTypeCi = mime(imagenCi.path).split('/'); //image/jpeg
    final mimeTypeantecedente = mime(imagenAntecedentes.path).split('/'); //image/jpeg
    final mimeTypeselfie = mime(selfie.path).split('/'); //image/jpeg

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file1 = await http.MultipartFile.fromPath('fotoCi', imagenCi.path,contentType: MediaType(mimeTypeCi[0], mimeTypeCi[1]));
    final file2 = await http.MultipartFile.fromPath('fotoAntecedentesPenales', imagenAntecedentes.path,contentType: MediaType(mimeTypeantecedente[0], mimeTypeantecedente[1]));
    final file3 = await http.MultipartFile.fromPath('fotoSelfieCi', selfie.path,contentType: MediaType(mimeTypeselfie[0], mimeTypeselfie[1]));
    // imageUploadRequest.headers.addAll(head);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token =  prefs.getString('token');

    imageUploadRequest.files.add(file1);
    imageUploadRequest.files.add(file2);
    imageUploadRequest.files.add(file3);
    imageUploadRequest.fields["ci"]= empleado.ci.toString();
    imageUploadRequest.fields["nombre"]= empleado.nombre;
    imageUploadRequest.fields["apellidoP"]= empleado.apellidoP;
    imageUploadRequest.fields["apellidoM"]= empleado.apellidoM;
    imageUploadRequest.fields["direccion"]= empleado.direccion;
    imageUploadRequest.fields["telefono"]= empleado.telefono.toString();
    imageUploadRequest.fields["fechaNacimiento"]= empleado.fechaNacimiento;
    imageUploadRequest.fields["token"]= token;

    final streamResponse = await imageUploadRequest.send();

    final resp = await http.Response.fromStream(streamResponse);
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');
      print(resp.body);
      return null;
    }
    final respData = json.decode(resp.body);
    print(respData);
    return respData;
  }

  Future<List<EmpleadoModel>> cargarEmpleados() async{
    final String _url = env.API_URL+'/api/empleado/all';
    final resp = await http.get(_url);
    final List decodedData = json.decode(resp.body);
    final List<EmpleadoModel> empleados = [];
    if ( decodedData == null) return [];
    decodedData.forEach((element) {
      final empleadoTemp = EmpleadoModel.fromJson(element);
      empleados.add(empleadoTemp);
    });
    return empleados;



  }

  Future<List<String>> login (String appelido,int password,String token) async {
    final String _url = env.API_URL;
    final url = '$_url/api/login';
    Map <String,String> head= {
      "Content-Type":"application/json",
    };
    Map <String,dynamic> body= {
      "apellidoP":appelido,
      "ci":password,
      "token":token
    };
    final resp = await http.post(url,headers: head ,body: jsonEncode(body));
    final decodedData = json.decode(resp.body);
    print(decodedData);
    List<String> respuesta = [ decodedData["id"].toString(),decodedData["tipo"].toString()];
    return respuesta;
    
  }

  //  Future<String> subirCi(File imagen) async {
  //   final url = Uri.parse('$_url/api/empleado/cargarfoto');
  //   final mimeType = mime(imagen.path).split('/'); //image/jpeg
  //   final imageUploadRequest = http.MultipartRequest('POST', url);
  //   final file = await http.MultipartFile.fromPath('fotoCi', imagen.path,
  //       contentType: MediaType(mimeType[0], mimeType[1]));
  //   imageUploadRequest.files.add(file);
  //   final streamResponse = await imageUploadRequest.send();
  //   final resp = await http.Response.fromStream(streamResponse);
  //   if (resp.statusCode != 200 && resp.statusCode != 201) {
  //     print('Algo salio mal');
  //     print(resp.body);
  //     return null;
  //   }
  //   final respData = json.decode(resp.body);
  //   print(respData);
  //   return respData['direccion'];
  // }

  // Future<String> subirAntecendetes(File imagen) async {
  //   final url = Uri.parse('$_url/api/empleado/cargarfoto');
  //   final mimeType = mime(imagen.path).split('/'); //image/jpeg
  //   final imageUploadRequest = http.MultipartRequest('POST', url);
  //   final file = await http.MultipartFile.fromPath(
  //       'fotoAntecedentesPenales', imagen.path,
  //       contentType: MediaType(mimeType[0], mimeType[1]));
  //   imageUploadRequest.files.add(file);
  //   final streamResponse = await imageUploadRequest.send();
  //   final resp = await http.Response.fromStream(streamResponse);
  //   if (resp.statusCode != 200 && resp.statusCode != 201) {
  //     print('Algo salio mal');
  //     print(resp.body);
  //     return null;
  //   }
  //   final respData = json.decode(resp.body);
  //   print(respData);
  //   return respData['direccion'];
  // }

  // Future<String> subirselfie(File imagen) async {
  //   final url = Uri.parse('$_url/api/empleado/cargarfoto');
  //   final mimeType = mime(imagen.path).split('/'); //image/jpeg
  //   final imageUploadRequest = http.MultipartRequest('POST', url);
  //   final file = await http.MultipartFile.fromPath('fotoSelfieCi', imagen.path,
  //       contentType: MediaType(mimeType[0], mimeType[1]));
  //   imageUploadRequest.files.add(file);
  //   final streamResponse = await imageUploadRequest.send();
  //   final resp = await http.Response.fromStream(streamResponse);
  //   if (resp.statusCode != 200 && resp.statusCode != 201) {
  //     print('Algo salio mal');
  //     print(resp.body);
  //     return null;
  //   }
  //   final respData = json.decode(resp.body);
  //   print(respData);
  //   return respData['direccion'];
  // }

}
