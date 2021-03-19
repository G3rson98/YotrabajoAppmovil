import 'package:flutter/material.dart';
import 'package:yotrabajo2/src/bloc/login_bloc.dart';
import 'package:yotrabajo2/src/bloc/provider.dart';
import 'package:yotrabajo2/src/providers/empleados_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {

  String apellido="";
  int ci;

  final formkey = GlobalKey<FormState>();
  EmpleadosProvider empleadoProvider = new EmpleadosProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        _crearFondo(context),
        _loginForm(context),
      ],
    ));
  }

  Widget _loginForm(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: 180.0,
            ),
          ),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ]),
            child: Form(
              key: formkey,
              child: Column(
                children: <Widget>[
                  Text('Ingreso', style: TextStyle(fontSize: 20.0)),
                  SizedBox(height: 60.0),
                  _crearEmail(),
                  SizedBox(height: 30.0),
                  _crearPassword(),
                  SizedBox(height: 30.0),
                  _crearBoton(context),
                  SizedBox(height: 30.0),
                  Text('¿Olvido la contraseña?'),
                ],
              ),
            ),
          ),
          registrar(context),
          SizedBox(height: 100.0)
        ],
      ),
    );
  }

  Widget registrar(BuildContext context) {
    return TextButton(
      child: Text('Registrarme'),
      onPressed: () => Navigator.pushReplacementNamed(context, 'Empleado'),
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      // textColor: Colors.white,
    );
  }

  Widget _crearEmail() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
            hintText: 'ejemplo@correo.com',
            labelText: 'Correo electrónico',
          ),
          onChanged: (value) => this.apellido=value,
          validator: (value) {
            if (value.length < 3) {
              return 'campo requerido';
            } else {
              return null;
            }
          }),
    );
  }

  Widget _crearPassword() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
            labelText: 'Contraseña',
          ),
          validator: (value) {
            if (value.length < 3) {
              return 'campo requerido';
            } else {
              return null;
            }
          },
          onChanged: (value) => this.ci=int.parse(value),
          ),
    );
  }

  Widget _crearBoton(BuildContext context ){
    return RaisedButton(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
          child: Text('Ingresar'),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        elevation: 0.0,
        color: Colors.deepPurple,
        textColor: Colors.white,
        onPressed: () async {
          if (!formkey.currentState.validate()) return;
          formkey.currentState.save();

          SharedPreferences prefs = await SharedPreferences.getInstance();
          String token =  prefs.getString('token');
          print(token);
          List<String> rep = await empleadoProvider.login(this.apellido, this.ci,token);

          prefs.setInt('idUsuario', int.parse(rep[0]));          
          if (rep[1].toString() == "empleado") {
            Navigator.of(context).pushNamed("listado");
          }else{

          }
          print(rep);
        });
  }

  _login(LoginBloc bloc, BuildContext context) {
    print('================');
    print('Email: ${bloc.email}');
    print('Password: ${bloc.password}');
    print('================');

    Navigator.pushReplacementNamed(context, 'home');
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final fondoModaro = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
        Color.fromRGBO(63, 63, 156, 1.0),
        Color.fromRGBO(90, 70, 178, 1.0)
      ])),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );

    return Stack(
      children: <Widget>[
        fondoModaro,
        Positioned(top: 90.0, left: 30.0, child: circulo),
        Positioned(top: -40.0, right: -30.0, child: circulo),
        Positioned(bottom: -50.0, right: -10.0, child: circulo),
        Positioned(bottom: 120.0, right: 20.0, child: circulo),
        Positioned(bottom: -50.0, left: -20.0, child: circulo),
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: <Widget>[
              Icon(Icons.person_pin_circle, color: Colors.white, size: 100.0),
              SizedBox(height: 10.0, width: double.infinity),
              Text('Yo Trabajo2.0',
                  style: TextStyle(color: Colors.white, fontSize: 25.0))
            ],
          ),
        )
      ],
    );
  }
}
