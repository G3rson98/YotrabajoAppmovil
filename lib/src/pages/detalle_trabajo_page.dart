import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yotrabajo2/src/models/oficio_model.dart';
import 'package:yotrabajo2/src/models/trabajo_model.dart';
import 'package:yotrabajo2/src/providers/trabajo_provider.dart';

class DetalleTrabajoPage extends StatefulWidget {
  final List<OficioModel> oficios;
  final int idPersona;
  const DetalleTrabajoPage({Key key, @required this.oficios, @required this.idPersona}) : super(key: key);
  @override
  _DetalleTrabajoPageState createState() => _DetalleTrabajoPageState();
}

class _DetalleTrabajoPageState extends State<DetalleTrabajoPage> {


  final formkey = GlobalKey<FormState>();
  TrabajoModel trabajo = new TrabajoModel();
  List<Detalle> detalles = [];
  
  TrabajoProvider trabajoProvider = new TrabajoProvider();



  @override
  Widget build(BuildContext context) {
    trabajo.idEmpleado=this.widget.idPersona;

    print(this.widget.oficios);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detalle del Trabajo",
        ),
      ),
      body: Container(
          margin: EdgeInsets.all(25.0),
          child: Form(
            key: formkey,
            child: ListView(
              children: <Widget>[
                    Text("Especificaciones:",
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold)),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                          labelText: 'Indicanos tu direccion',
                          focusColor: Colors.black),
                      onSaved: (value) => trabajo.direccion = value,
                      validator: (value) {
                        if (value.length < 3) {
                          return 'ingresa tu direccion';
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                          labelText: 'En que momento?',
                          focusColor: Colors.black),
                      onSaved: (value) => trabajo.horario=value,
                      validator: (value) {
                        if (value.length < 3) {
                          return 'ingresa el horario';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: 25.0,
                    )
                  ] +
                  this.widget.oficios.map(crearDetalls).toList() +
                  <Widget>[
                    SizedBox(
                      height: 15.0,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _submit(context);
                        },
                        child: Text("Confirmar"))
                  ],
            ),
          )),
    );
  }

  Widget crearDetalls(OficioModel oficio) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Column(
        children: [
          Text(
            oficio.nombre,
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
          TextFormField(
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
                labelText: 'quieres Especificar algo?',
                focusColor: Colors.black),
            onSaved: (value) => detalles.add(new Detalle(nombredetalle: oficio.nombre,encargo: value)),
            validator: (value) {
                        if (value.length < 3) {
                          return 'especifica el trabajo!';
                        } else {
                          return null;
                        }
                      },
          )
        ],
      ),
    );
  }

  void _submit(BuildContext context) async {
    if (!formkey.currentState.validate()) return;
    formkey.currentState.save();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    trabajo.idContratante = prefs.getInt('idUsuario');
    
    trabajo.detalle =  this.detalles;
    bool exito =await trabajoProvider.crearTrabajo(trabajo);
    Navigator.pop(context);
    print("exito");

  }
}
