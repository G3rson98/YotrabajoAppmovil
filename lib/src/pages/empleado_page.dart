
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:day_picker/day_picker.dart';
import 'package:time_range/time_range.dart';

import 'package:yotrabajo2/src/utils/utils.dart' as utils;

import 'package:yotrabajo2/src/models/empleado_model.dart';
import 'package:yotrabajo2/src/models/horario_model.dart';
import 'package:yotrabajo2/src/models/oficio_model.dart';
import 'package:yotrabajo2/src/providers/empleados_provider.dart';
import 'package:yotrabajo2/src/providers/horario_provider.dart';
import 'package:yotrabajo2/src/providers/oficios_provider.dart';

class EmpleadoPage extends StatefulWidget {
  //const EmpleadoPage({Key key}) : super(key: key);

  @override
  _EmpleadoPageState createState() => _EmpleadoPageState();
}

class _EmpleadoPageState extends State<EmpleadoPage> {
  // >>>>>>>>>>>VARIABLES<<<<<<<<<<<<<<<<<<<<<<
  final formkey = GlobalKey<FormState>();

  final empleadoProvider = new EmpleadosProvider();

  final horarioProvider = new HorarioProvider();

  final oficiosProvider = new OficiosProvider();

  String _fecha;
  File fotoCi;
  File fotoSelfie;
  File fotoAntecedentes;
  int _currentStep = 0;

  TextEditingController _inputFieldDateController = new TextEditingController();

  EmpleadoModel empleado = new EmpleadoModel();

  List<OficioModel> marcados = [];

  List<String> dias = [];
  List<HorarioModel> horarios = [];

//>>>>>>>>>>>>>>>>>>>>>>>>>CODIGO>>>>>>>>>>>>>>>>>>>>>>>>
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro Empleado'),
      ),
      body: SingleChildScrollView(
        child: Container(
          //padding: EdgeInsets.all(15.0),
          child: Form(
              key: formkey,
              child: Stepper(
                currentStep: _currentStep,
                steps: _steps(),
                onStepContinue: () {
                  setState(() {
                    print("pasos" + _currentStep.toString());
                    if (this._currentStep == 2) {
                      horarios = new List();
                      marcados.forEach((element) {
                        horarios.add(new HorarioModel(idOficio: element.id));
                      });
                    }
                    if (this._currentStep < this._steps().length - 1) {
                      this._currentStep = this._currentStep + 1;                      
                    } else {
                      //your Code
                      _submit();
                      print('Complete');
                    }
                  });
                },
                onStepCancel: () {
                  setState(() {
                    Navigator.pushReplacementNamed(context, 'login');
                  });
                },
                physics: ClampingScrollPhysics(),
              )),
        ),
      ),
    );
  }

  List<Step> _steps() {
    List<Step> _steps = [
      _datosPersonales(),
      _fotosDeDocumentos(),
      _oficios(),
      _horario()
    ];
    return _steps;
  }

  Step _datosPersonales() {
    return Step(
        title: Text('Datos Personales'),
        content: Column(
          children: <Widget>[
            _crearCi(),
            _crearNombre(),
            _crearApellidoPaterno(),
            _crearApellidoMaterno(),
            _crearDireccion(),
            _crearFecha(context),
            _crearTelefono(),
          ],
        ));
  }

  Step _fotosDeDocumentos() {
    return Step(
        title: Text('Documentos'),
        content: Column(
          children: <Widget>[
            Container(
              child: Text('Foto de Ci:'),
              alignment: Alignment.centerLeft,
            ),
            _crearFotoCi(),
            SizedBox(
              height: 15.0,
            ),
            Container(
              child: Text('Foto de Antecedentes Penales:'),
              alignment: Alignment.centerLeft,
            ),
            _crearFotoAntecedentes(),
            SizedBox(
              height: 15.0,
            ),
            Container(
              child: Text('Foto Selfie con Ci:'),
              alignment: Alignment.centerLeft,
            ),
            _crearFotoSelfie()
          ],
        ));
  }

  Step _oficios() {
    return Step(
        title: Text('Oficios'),
        content: Row(
          children: <Widget>[
            Expanded(
              child: _crearListadoOficios(),
            )
          ],
        ));
  }

  Step _horario() {
    return Step(
        title: Text('Horario'),
        content: Row(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: marcados.length,
                itemBuilder: (context, i) {
                  return _crearHorario(context, marcados[i]);
                },
              ),
            )
          ],
        ));
  }

  

  Widget _crearHorario(BuildContext context, OficioModel oficio) {
    return Column(
      children: <Widget>[
        Text('${oficio.nombre}'),
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectWeekDays(
                  border: false,
                  boxDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      colors: [
                        const Color(0xFFE55CE4),
                        const Color(0xFFBB75FB)
                      ],
                      tileMode: TileMode
                          .repeated, // repeats the gradient over the canvas
                    ),
                  ),
                  onSelect: (values) {
                    horarios.forEach((element) {
                      if (element.idOficio == oficio.id) {
                        element.dias = values.toString();
                      }
                    });
                    //print(values);
                  },
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: <Widget>[
            Expanded(
                child:TimeRange(
              fromTitle: Text(
                'desde',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              toTitle: Text(
                'hasta',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              titlePadding: 20,
              textStyle: TextStyle(
                  fontWeight: FontWeight.normal, color: Colors.black87),
              activeTextStyle:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              borderColor: Colors.black12,
              backgroundColor: Colors.transparent,
              activeBackgroundColor: Colors.orange,
              firstTime: TimeOfDay(hour: 6, minute: 00),
              lastTime: TimeOfDay(hour: 22, minute: 00),
              timeStep: 30,
              timeBlock: 30,
              onRangeCompleted: (range) {
                horarios.forEach((element) {
                  if (element.idOficio == oficio.id) {
                    element.horaInicio = range.start.toString();
                    element.horaFin = range.end.toString();
                  }
                });
                print(horarios.length);
                setState(() {
                  // print(range.start);
                  // print(range.end);
                });
              },
            )),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    );
  }

  Widget _crearNombre() {
    return TextFormField(
        //initialValue: empleado.tipo,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: 'Nombre'),
        validator: (value) {
          if (value.length < 3) {
            return 'ingrese el nombre del producto';
          } else {
            return null;
          }
        },
        onSaved: (value) => empleado.nombre = value);
  }

  Widget _crearApellidoPaterno() {
    return TextFormField(
        //initialValue: empleado.tipo,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: 'Apellido Paterno'),
        validator: (value) {
          if (value.length < 2) {
            return 'ingrese un apellido valido';
          } else {
            return null;
          }
        },
        onSaved: (value) => empleado.apellidoP = value);
  }

  Widget _crearApellidoMaterno() {
    return TextFormField(
        //initialValue: empleado.tipo,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: 'Apellido Materno'),
        validator: (value) {
          if (value.length < 2) {
            return 'ingrese un apellido valido';
          } else {
            return null;
          }
        },
        onSaved: (value) => empleado.apellidoM = value);
  }

  Widget _crearDireccion() {
    return TextFormField(
        //initialValue: empleado.tipo,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: 'Direccion'),
        validator: (value) {
          if (value.length < 10) {
            return 'ingrese un direccion valida';
          } else {
            return null;
          }
        },
        onSaved: (value) => empleado.direccion = value);
  }

  Widget _crearTelefono() {
    return TextFormField(
        keyboardType: TextInputType.phone,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: 'Telefono'),
        validator: (value) {
          if (utils.isNumeric(value)) {
            return null;
          } else {
            return 'Solo numeros';
          }
        },
        onSaved: (value) => empleado.telefono = int.parse(value));
  }

  Widget _crearCi() {
    return TextFormField(
        keyboardType: TextInputType.phone,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: 'Carnet de Identidad'),
        validator: (value) {
          if (utils.isNumeric(value)) {
            return null;
          } else {
            return 'Solo numeros';
          }
        },
        onSaved: (value) => empleado.ci = int.parse(value));
  }

  _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime(1998),
        firstDate: new DateTime(1980),
        lastDate: new DateTime(2003),
        locale: Locale('es', 'ES'));

    if (picked != null) {
      setState(() {
        _fecha = picked.day.toString() +
            "-" +
            picked.month.toString() +
            "-" +
            picked.year.toString();
        _inputFieldDateController.text = _fecha;
      });
    }
  }

  Widget _crearFecha(BuildContext context) {
    return TextFormField(
        enableInteractiveSelection: false,
        controller: _inputFieldDateController,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: 'Fecha de nacimiento'),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectDate(context);
        },
        onSaved: (value) => empleado.fechaNacimiento = value);
  }

  Widget _crearPrecio() {
    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Precio'),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Solo numeros';
        }
      },
    );
  }

  Widget _mostrarFotoCi() {
    if (empleado.fotoCi != null) {
      // TODO: tengo que hacer esto
      return Container();
    } else {
     if( fotoCi != null ){
        return Image.file(
          fotoCi,
          fit: BoxFit.cover,
          height: 10.0,
          width: 10.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }

  _seleccionarFotoCi() async {
    this.fotoCi = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (fotoCi != null) {
      //limpieza
    }
    setState(() {});
  }

  Widget _crearFotoCi() {
    return Container(
      child: Row(
        children: <Widget>[
          IconButton(
              iconSize: 40.0,
              icon: Icon(Icons.photo),
              onPressed: _seleccionarFotoCi),
          SizedBox(
            width: 50.0,
          ),
          Container(child: _mostrarFotoCi(),height: 125.0, width: 125.0,)
        ],
      ),
    );
  }

  Widget _mostrarFotoAntecedentes() {
    if (empleado.fotoAntecedentesPenales != null) {
      // TODO: tengo que hacer esto
      return Container();
    } else {
      if( fotoAntecedentes != null ){
        return Image.file(
          fotoAntecedentes,
          fit: BoxFit.cover,
          height: 10.0,
          width: 10.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }

  _seleccionarFotoAntecedentes() async {
    fotoAntecedentes = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (fotoAntecedentes != null) {
      //limpieza
    }
    setState(() {});
  }

  Widget _crearFotoAntecedentes() {
    return Container(
      child: Row(
        children: <Widget>[
          IconButton(
              iconSize: 40.0,
              icon: Icon(Icons.photo),
              onPressed: _seleccionarFotoAntecedentes),
          SizedBox(
            width: 50.0,
          ),
          Container(child: _mostrarFotoAntecedentes(),height: 125.0, width: 125.0,)
        ],
      ),
    );
  }

  Widget _mostrarFotoSelfie() {
    if (empleado.fotoSelfieCi != null) {
      // TODO: tengo que hacer esto
      return Container();
    } else {
      if( fotoSelfie != null ){
        return Image.file(
          fotoSelfie,
          fit: BoxFit.cover,
          height: 10.0,
          width: 10.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }

  _seleccionarFotoSelfie() async {
    fotoSelfie = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (fotoSelfie != null) {
      //limpieza
    }
    setState(() {});
  }

  Widget _crearFotoSelfie() {
    return Container(
      child: Row(
        children: <Widget>[
          IconButton(
              iconSize: 40.0,
              icon: Icon(Icons.photo),
              onPressed: _seleccionarFotoSelfie),
          SizedBox(
            width: 50.0,
          ),
          Container(child: _mostrarFotoSelfie(),height: 125.0, width: 125.0,)
        ],
      ),
    );
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.deepPurple,
      textColor: Colors.white,
      icon: Icon(Icons.save),
      label: Text('Guardar'),
      onPressed: _submit,
    );
  }


  void _submit() async {
    bool resp;
    int idPersona;
    if (!formkey.currentState.validate()) return;
      formkey.currentState.save();
    //se cargan las fotos
    if (fotoCi != null && fotoAntecedentes != null && fotoSelfie != null) {
        idPersona= await empleadoProvider.cargarFotos(fotoCi,fotoAntecedentes,fotoSelfie,empleado);
        print(idPersona);
    }
    //se crean los horarios

    bool res = await horarioProvider.crearHorario(horarios,idPersona);
    // print(empleado.toJson());
    
    Navigator.of(context).pushReplacementNamed('login');
  }

  Widget _crearListadoOficios() {
    return FutureBuilder(
        future: oficiosProvider.cargarOficios(),
        builder:
            (BuildContext context, AsyncSnapshot<List<OficioModel>> snapshot) {
          if (snapshot.hasData) {
            final oficios = snapshot.data;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: oficios.length,
              itemBuilder: (context, i) =>
                  _crearItemOficio(context, oficios[i]),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  _oficioMarcado(int id) {
    bool resultado = false;
    marcados.forEach((element) {
      if (element.id == id) {
        resultado = true;
      }
    });
    return resultado;
  }

  Widget _crearItemOficio(BuildContext context, OficioModel oficio) {
    return CheckboxListTile(
      value: _oficioMarcado(oficio.id),
      onChanged: (value) {
        //ismarcado =! ismarcado;
        setState(() {
          if (value) {
            marcados.add(oficio);
          } else {
            marcados.remove(oficio);
          }
        });
      },
      title: Text('${oficio.nombre}'),
    );
  }
}
