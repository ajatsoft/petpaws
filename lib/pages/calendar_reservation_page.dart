import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  //---------wavess-------
  _buildCard({
    Config config,
    Color backgroundColor = Colors.transparent,
  }) {
    return WaveWidget(
      config: config,
      backgroundColor: backgroundColor,
      size: Size(
        double.infinity,
        150.0,
      ),
      waveAmplitude: 0,
    );
  }
  //-----fin   waves------

  //-----controlodaor para calendartable--
  CalendarController _controller;
  //.....fecha cuando selecciona en duro y formateado
  DateTime daySelected;
  String fechaSelected;

  @override
  void initState() {
    //-----inicializar el controlador para usar el calendario--
    super.initState();
    _controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    //variable para recibir datos de perfil veterinaria
    List prodData = ModalRoute.of(context).settings.arguments;
    String nombreServicio = prodData[0];
    int duracionCita = prodData[1];
    Map horarios = prodData[2];
    final idservicio = prodData[3];
    final idveterinaria = prodData[4];

    //variable para captar horas de iniicio y final del mapa
    int _horainicio;
    int _horafinal;
    //-------------------------
    int _anoFinal;
    int _mesFinal;
    int _diaFinal;

    //fecha final x mas que no se selccione toma la fecha de hoy dia
    DateTime fechaFinal;
    var today = DateTime.now();
    var fechaHoy = DateFormat('EEEE, d MMMM, ' 'yyyy', 'es_ES').format(today);
    var nombreDia = DateFormat('EEEE', 'es_ES').format(today);
    //probando valores para el año, mes, dia
    var nombreAno = DateFormat('yyyy', 'es_ES').format(today);
    var nombreMes = DateFormat('MM', 'es_ES').format(today);
    var numDia = DateFormat('dd').format(today);

    //asginar valores a las variables hora de inicio y final
    try {
      if (daySelected == null) {
        _horainicio = horarios['$nombreDia']['inicio'];
        _horafinal = horarios['$nombreDia']['final'];
        _anoFinal = int.parse(nombreAno);
        _mesFinal = int.parse(nombreMes);
        _diaFinal = int.parse(numDia);
      } else {
        var clickDay = DateFormat('EEEE', 'es_ES').format(daySelected);
        _horainicio = horarios['$clickDay']['inicio'];
        _horafinal = horarios['$clickDay']['final'];
        _anoFinal = int.parse(DateFormat('yyyy', 'es_ES').format(daySelected));
        _mesFinal = int.parse(DateFormat('MM', 'es_ES').format(daySelected));
        _diaFinal = int.parse(DateFormat('dd', 'es_ES').format(daySelected));
      }
    } catch (e) {
      print('lo sentimos no hay atención');
    }
    print('**********************************');
    print(_horainicio);
    print(_horafinal);
    print(_anoFinal);
    print(_mesFinal);
    print(_diaFinal);

    //lista para ir almacenando los tiempos sumado al intervalo
    List daysHora = [];
    List daysFecha = [];
    if (_horainicio != null && _horafinal != null) {
      DateTime startDate =
          new DateTime(_anoFinal, _mesFinal, _diaFinal, _horainicio, 00);
      DateTime endDate =
          new DateTime(_anoFinal, _mesFinal, _diaFinal, _horafinal, 00);
      DateTime tmp = DateTime(startDate.year, startDate.month, startDate.day,
          startDate.hour, startDate.minute);
      //ciclo while para generar las horas y guardarlo en la lista days
      do {
        var hora = DateFormat('h:mm a').format(tmp);
        daysHora.add(hora);
        daysFecha.add(tmp);
        tmp = tmp.add(new Duration(minutes: duracionCita));
      } while (DateTime(tmp.year, tmp.month, tmp.day, tmp.hour, tmp.minute) !=
          endDate);
    } else {}
    print('*********************************');
    print(daysFecha);
    print(daysHora);
    print(duracionCita);
    print(horarios);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffffffff),
        body: Stack(
          children: [
            titulo(),
            Padding(
              padding: EdgeInsets.only(top: 80.0),
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0XFFED278A), width: 2)),
                    child: TableCalendar(
                      initialSelectedDay: DateTime.now(),
                      onDaySelected: _onDaySelected,
                      initialCalendarFormat: CalendarFormat.week,
                      availableCalendarFormats: {CalendarFormat.week: 'Semana'},
                      locale: 'es_ES',
                      calendarController: _controller,
                      calendarStyle: CalendarStyle(
                        todayColor: Theme.of(context).primaryColor,
                        todayStyle: TextStyle(
                            //-----actual fecha------
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                        //-----seleccion fecha----
                        selectedColor: Color(0xFFFDD400),
                        selectedStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      headerStyle: HeaderStyle(
                        centerHeaderTitle: true,
                      ),
                      startingDayOfWeek: StartingDayOfWeek.monday,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Container(
                          padding: EdgeInsets.only(left: 20, bottom: 20),
                          child: daySelected == null
                              ? Text(
                                  '$fechaHoy',
                                  style: TextStyle(fontSize: 20),
                                )
                              : Text('$fechaSelected',
                                  style: TextStyle(fontSize: 20)))
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 330,
                        padding: EdgeInsets.only(right: 20, left: 20),
                        child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            childAspectRatio: 3,
                          ),
                          itemCount: daysHora.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                if (daySelected == null) {
                                  fechaFinal = today;
                                } else {
                                  fechaFinal = daySelected;
                                }
                                print('esta es la fecha');
                                print(fechaFinal);
                                print(daysHora[index]);
                                print('----horas finales.....');
                                print(_anoFinal);
                                print(_mesFinal);
                                print(_diaFinal);
                                print(daysFecha[index]);
                                DateTime oneDaysAgo =
                                    today.subtract(new Duration(days: 1));
                                print(oneDaysAgo);

                                if (fechaFinal.isAfter(oneDaysAgo)) {
                                  Navigator.pushNamed(context, 'ReservaService',
                                      arguments: [
                                        nombreServicio,
                                        daysHora[index],
                                        daysFecha[index],
                                        duracionCita,
                                        idservicio,
                                        idveterinaria,
                                      ]);
                                } else {
                                  return showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          title: Text(
                                            'Error en la Fecha',
                                            textAlign: TextAlign.center,
                                          ),
                                          content: Text(
                                              'No puede reservar en una \nfecha anterior al de hoy'),
                                          actions: [
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Okay'))
                                          ],
                                        );
                                      });
                                }
                              },
                              child: Container(
                                child: Center(
                                    child: Text(daysHora[index],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                                decoration: BoxDecoration(
                                    color: Color(0XFFED278A),
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //cuando selecciona la fecha
  void _onDaySelected(DateTime day, List events) {
    setState(() {
      daySelected = day;
      fechaSelected = DateFormat('EEEE, d MMMM, ' 'yyyy', 'es_ES').format(day);
      print(fechaSelected);
    });
  }

  Widget titulo() {
    return Container(
      child: Stack(
        children: [
          _buildCard(
            config: CustomConfig(
              colors: [
                Colors.white70,
                Colors.white54,
                Colors.white30,
                Colors.white,
              ],
              durations: [32000, 21000, 18000, 5000],
              heightPercentages: [0.31, 0.35, 0.40, 0.41],
            ),
            backgroundColor: Colors.deepPurpleAccent[400],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //----WIDGET REGRESO A PERFIL VETERINARIA---
              Wrap(
                direction: Axis.vertical,
                alignment: WrapAlignment.center,
                runSpacing: 1.0,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 20,
                      left: 18,
                    ),
                    child: GestureDetector(
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              //----TITULO DE LA SECCION---
              Padding(
                padding: const EdgeInsets.only(
                  top: 15.0,
                  right: 100,
                ),
                child: Text(
                  "Elíge una fecha y una hora",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}