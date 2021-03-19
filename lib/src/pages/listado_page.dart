import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yotrabajo2/src/models/empleado_model.dart';
import 'package:yotrabajo2/src/pages/perfil_page.dart';
import 'package:yotrabajo2/src/providers/empleados_provider.dart';

class ListadoPage extends StatefulWidget {
  @override
  _ListadoPageState createState() => _ListadoPageState();
}

class _ListadoPageState extends State<ListadoPage> {
  final empleadoProvider = new EmpleadosProvider();
  Future<List<EmpleadoModel>> empleados;
  @override
  void initState() {
    empleados = empleadoProvider.cargarEmpleados();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Empleados"),
        ),
        body: FutureBuilder(
            future: empleadoProvider.cargarEmpleados(),
            builder: (BuildContext context,
                AsyncSnapshot<List<EmpleadoModel>> snapshot) {
              if (snapshot.hasData) {
                final empleados = snapshot.data;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: empleados.length,
                  itemBuilder: (context, i) =>
                      personDetailCard(context, empleados[i]),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }

  Widget personDetailCard(BuildContext context, EmpleadoModel empleado) {
    return Container(
      height: 120,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      "https://p7.hiclipart.com/preview/954/328/914/computer-icons-user-profile-avatar.jpg")))),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          empleado.nombre,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          empleado.apellidoP + " " + empleado.apellidoM,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellow[800],
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.yellow[800],
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.yellow[800],
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                IconButton(
                    icon: Icon(Icons.navigate_next),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PerfilPage(empleado: empleado,),
                          ));
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
