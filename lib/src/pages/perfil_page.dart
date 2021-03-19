import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:yotrabajo2/src/models/empleado_model.dart';
import 'package:yotrabajo2/src/models/horario_model.dart';
import 'package:yotrabajo2/src/models/oficio_model.dart';
import 'package:yotrabajo2/src/pages/detalle_trabajo_page.dart';
import 'package:yotrabajo2/src/providers/oficios_provider.dart';

class PerfilPage extends StatefulWidget {
  final EmpleadoModel empleado;
  const PerfilPage({Key key, @required this.empleado}) : super(key: key);
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {

  List<OficioModel> marcados = [];

  Future<List<OficioModel>> oficios;

  final OficiosProvider oficiosProv = new OficiosProvider();

  @override
  void initState() {
    oficios = oficiosProv.cargarOficiosEmpleado(this.widget.empleado.id);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print(this.widget.empleado.nombre);
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil de Usuario"),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Color(0xfffe1f0ff)),
          child: Column(children: [
            Container(
              height: 500,
              decoration: BoxDecoration(color: Color(0xfffe7e9f5)),
              child: Stack(
                children: [
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    bottom: 150.0,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        fit: BoxFit.contain,
                        imageUrl:
                            "https://eshendetesia.com/images/user-profile.png",
                        fadeInCurve: Curves.easeIn,
                        fadeInDuration: Duration(seconds: 1),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ClipPath(
                      clipper: MyCustomClipper(),
                      child: Container(
                        height: 300,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 400.0,
                    left: 10.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: Column(children: [
                      Text(
                        this.widget.empleado.nombre,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star_rounded,
                                  color: Colors.yellow[800]),
                              Icon(Icons.star_rounded,
                                  color: Colors.yellow[800]),
                              Icon(Icons.star_rounded,
                                  color: Colors.yellow[800]),
                              Icon(Icons.star_rounded,
                                  color: Colors.yellow[800]),
                              Icon(Icons.star_rounded,
                                  color: Colors.yellow[800]),
                            ],
                          ),
                        ],
                      )
                    ]),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(15.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Telefono de contaco: "+this.widget.empleado.telefono.toString(),style: TextStyle(fontSize: 18.0),)
                    ],
                  ),
                  SizedBox(height: 10.0,),
                  Text(
                    'Descripción',
                    style:
                        TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  _crearListadoOficios(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton( child: Text("Contratar"),onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => DetalleTrabajoPage(oficios: marcados,idPersona: this.widget.empleado.id,),
                          ));
                      },),
                    ],
                  ), 
                  
                ],
              ),
            ),
            SizedBox(height: 20.0),
            valoraciones(context),
            SizedBox(height: 20.0),
            comentar(context),
            SizedBox(height: 20.0),
          ]),
        ),
      ),
    );
  }

  Container comentar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.all(15.0),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Envia tu opinion',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          SizedBox(height: 5),
          RatingBar(
            initialRating: 3,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            ratingWidget: RatingWidget(
              full: Icon(
                Icons.star_rounded,
                color: Colors.yellow[800],
              ),
              half: Icon(Icons.star_half_rounded),
              empty: Icon(
                Icons.star_border_rounded,
                color: Colors.grey,
              ),
            ),
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'Comentario',
            ),
            autofocus: false,
            maxLines: null,
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 20),
          Container(
            height: 40.0,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              color: Color(0xfff100dd1),
              textColor: Colors.white,
              onPressed: () {},
              child: Text(
                'Enviar',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container valoraciones(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Valoraciones',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          SizedBox(height: 10),
          _cardPersonaValoracion(),
          Divider(color: Colors.black),
          _cardPersonaValoracion(),
          Divider(color: Colors.black),
          _cardPersonaValoracion(),
          Divider(color: Colors.black)
        ],
      ),
    );
  }

  Widget _cardPersonaValoracion() {
    return Row(
      children: [
        Container(
          height: 45.0,
          child: ClipOval(
            child: Image(
              image: NetworkImage(
                'https://icons-for-free.com/iconfiles/png/512/business+costume+male+man+office+user+icon-1320196264882354682.png',
              ),
            ),
          ),
        ),
        SizedBox(width: 18),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  color: Colors.yellow[800],
                  size: 20,
                ),
                Icon(
                  Icons.star_rounded,
                  color: Colors.yellow[800],
                  size: 20,
                ),
                Icon(
                  Icons.star_rounded,
                  color: Colors.yellow[800],
                  size: 20,
                ),
                Icon(
                  Icons.star_rounded,
                  color: Colors.yellow[800],
                  size: 20,
                ),
                Icon(
                  Icons.star_rounded,
                  color: Colors.yellow[800],
                  size: 20,
                ),
              ],
            ),
            SizedBox(height: 3),
            Text(
              'Muy buen producto',
              style: TextStyle(fontSize: 16.0, color: Color(0xfff747794)),
            ),
            Text(
              '8 Nov 2020',
              style: TextStyle(fontSize: 13.0, color: Color(0xfff747794)),
            )
          ],
        )
      ],
    );
  }

  Widget _crearListadoOficios() {
    return FutureBuilder(
        future: oficiosProv.cargarOficiosEmpleado(this.widget.empleado.id),
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
        print(value);
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

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var controlPoint = Offset(size.width - 40, size.height / 2);
    var controlPoint2 = Offset(10, size.width / 2.8);

    var endPoint = Offset(size.width / 2, size.height / 2);
    var endPoint2 = Offset(0, size.height - 100);

    Path path = Path()
      ..moveTo(size.width, 0)
      ..quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx,
          endPoint.dy) // Add line p1p2
      ..lineTo(70, size.height / 2)
      ..quadraticBezierTo(
          controlPoint2.dx, controlPoint2.dy, endPoint2.dx, endPoint2.dy)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height) // Add line p2p3
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
