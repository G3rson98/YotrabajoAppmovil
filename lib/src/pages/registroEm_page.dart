import 'package:flutter/material.dart';

class RegistroEm extends StatefulWidget {
  RegistroEm({Key key}) : super(key: key);

  @override
  _RegistroEmState createState() => _RegistroEmState();
}

class _RegistroEmState extends State<RegistroEm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro Empleado'),
      ),
      body: Stepper(
        steps: _steps(),
        onStepContinue: () {
          
        },
        ),
    );
  }

  List<Step>_steps() {
    List<Step> _steps = [
      Step(
        title: Text('Datos Personales'), 
        content: 
        Column(
          children: <Widget>[
            _crearNombre(),
          ],
        )
      ),
    ];

    return _steps;
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
    );
  }
}