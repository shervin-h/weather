import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CompassScreen extends StatefulWidget {
  const CompassScreen({Key? key}) : super(key: key);

  static const String routeName = '/compass-screen';

  @override
  State<CompassScreen> createState() => _CompassScreenState();
}

class _CompassScreenState extends State<CompassScreen> with AutomaticKeepAliveClientMixin{

  Future<bool> _hasLocationPermission() async {
    PermissionStatus status = await Permission.locationWhenInUse.status;
    return status == PermissionStatus.granted;
  }

  Future<void> _requestLocationPermission() async{
    await Permission.locationWhenInUse.request().then((ignored) => {});
  }

  @override
  void initState() {
    super.initState();
    _hasLocationPermission().then((bool result) {
      if (!result) {
        _requestLocationPermission();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: StreamBuilder<CompassEvent>(
                stream: FlutterCompass.events,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CupertinoActivityIndicator(
                        color: context.theme.colorScheme.primary,
                        radius: 16,
                      ),
                    );
                  } else {
                    if (snapshot.hasError) {
                      return Text('Error reading heading: ${snapshot.error}');
                    } else if (snapshot.hasData && snapshot.data != null) {
                      // The heading varies from 0-360, 0 being north.
                      double? direction = snapshot.data!.heading;

                      // debugPrint('direction: $direction');

                      // if direction is null, then device does not support this sensor
                      // show error message
                      if (direction == null) {
                        return Center(
                          child: Text(
                            'Device does not have sensors !',
                            style: context.textTheme.bodyText1!.copyWith(
                              color: context.theme.errorColor,
                            ),
                          ),
                        );
                      }

                      // debugPrint('direction $direction');

                      return Container(
                        padding: const EdgeInsets.all(8),
                        width: context.width * 0.9,
                        height:  context.width * 0.9,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Align(
                            //   alignment: Alignment.topCenter,
                            //   child: Text(
                            //     'N',
                            //     style: context.textTheme.headline6,
                            //     textAlign: TextAlign.center,
                            //   ),
                            // ),
                            // Align(
                            //   alignment: Alignment.bottomCenter,
                            //   child: Text(
                            //     'S',
                            //     style: context.textTheme.headline6,
                            //     textAlign: TextAlign.center,
                            //   ),
                            // ),
                            // Align(
                            //   alignment: Alignment.centerLeft,
                            //   child: Text(
                            //     'W',
                            //     style: context.textTheme.headline6,
                            //     textAlign: TextAlign.center,
                            //   ),
                            // ),
                            // Align(
                            //   alignment: Alignment.centerRight,
                            //   child: Text(
                            //     'E',
                            //     style: context.textTheme.headline6,
                            //     textAlign: TextAlign.center,
                            //   ),
                            // ),

                            Transform.rotate(
                              angle: (direction * (math.pi / 180) * -1),
                              child:
                              SizedBox(
                                width: context.width * 0.7,
                                height: context.width * 0.7,
                                child: _getCompassRadialGauge(
                                  context: context,
                                  pointerValue: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                      // return Material(
                      //     shape: const CircleBorder(),
                      //     clipBehavior: Clip.antiAlias,
                      //     elevation: 4.0,
                      //     child: Container(
                      //       padding: const EdgeInsets.all(16.0),
                      //       alignment: Alignment.center,
                      //       decoration: const BoxDecoration(
                      //         shape: BoxShape.circle,
                      //       ),
                      //       child: Transform.rotate(
                      //         angle: (direction * (math.pi / 180) * -1),
                      //         child: Image.asset(
                      //           'assets/images/compass.jpg',
                      //           fit: BoxFit.cover,
                      //         ),
                      //       ),
                      //     ),
                      //   );
                    } else {
                      return Container();
                    }
                  }
                },
              ),
            ),
            Text('Compass', style: context.textTheme.headline6,)
          ],
        ),
      ),
    );
  }


  Widget _getCompassRadialGauge({required BuildContext context, required double pointerValue}) {
    return Transform.rotate(
      angle: (math.pi / 2) * 3,
      child: SfRadialGauge(
        animationDuration: 1000,
        enableLoadingAnimation: true,
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 360,
            startAngle: 0,
            endAngle: 360,
            // interval: 45,
            showLabels: false,
            labelsPosition: ElementsPosition.inside,
            // labelFormat: '{value}E',
            showTicks: false,
            axisLineStyle:  const AxisLineStyle(
              thicknessUnit: GaugeSizeUnit.factor,
              thickness: 1,
              color: Colors.white,
              // gradient: SweepGradient(
              //   colors: [
              //     // Colors.lightBlueAccent,
              //     // Colors.blueAccent,
              //     // Colors.purple,
              //     // Colors.purpleAccent,
              //     // Colors.pink,
              //     // Colors.red,
              //     // Colors.deepOrange,
              //     // Colors.orange,
              //     // Colors.green,
              //     // Colors.lightBlueAccent,
              //     Colors.grey.shade800,
              //     Colors.grey.shade700,
              //     Colors.grey.shade800,
              //     Colors.grey.shade700,
              //     Colors.grey.shade800,
              //   ],
              // ),
            ),
            ranges: <GaugeRange>[
              GaugeRange(
                startValue: 0,
                endValue: 360,
                sizeUnit: GaugeSizeUnit.factor,
                startWidth: 0.2,
                endWidth: 0.2,
                color: Colors.grey.shade800,
                // gradient: const SweepGradient(
                //   colors: [
                //     Color(0xFF0E0E0E),
                //     Color(0xFF101010),
                //     Color(0xFF202020),
                //     Color(0xFF434343),
                //     Color(0xFF202020),
                //     Color(0xFF101010),
                //     Color(0xFF0E0E0E),
                //     Color(0xFF101010),
                //     Color(0xFF202020),
                //     Color(0xFF434343),
                //     Color(0xFF202020),
                //     Color(0xFF101010),
                //     Color(0xFF0E0E0E),
                //   ],
                // ),
              ),
            ],
            pointers: <GaugePointer>[
              NeedlePointer(
                value: pointerValue,
                enableAnimation: true,
                needleStartWidth: 1,
                needleEndWidth: 10,
                gradient: LinearGradient(
                  colors: [
                    Colors.red.shade300,
                    Colors.red.shade500,
                    Colors.red.shade700,
                    Colors.red.shade900,
                  ],
                ),
                // tailStyle: TailStyle(
                //   lengthUnit: GaugeSizeUnit.factor,
                //   length: 0.4,
                //   width: 6,
                //   color: Colors.grey.shade700,
                //   borderWidth: 2,
                //   borderColor: Colors.black,
                // ),
              ),
            ],
            annotations: <GaugeAnnotation>[
              // GaugeAnnotation(
              //   widget: RotatedBox(
              //     quarterTurns: 1,
              //     child: Text(
              //       'Compass',
              //       style: context.textTheme.headline6!.copyWith(
              //         color: Colors.black.withOpacity(0.8),
              //       ),
              //     ),
              //   ),
              //   angle: 180,
              //   positionFactor: 1,
              // ),
            ],
          ),
          RadialAxis(
            minimum: 0,
            maximum: 360,
            startAngle: 0,
            endAngle: 360,
            interval: 22.5,
            showLabels: false,
            canRotateLabels: true,
            canScaleToFit: true,
            showTicks: false, // true
            tickOffset: 0,
            ticksPosition: ElementsPosition.inside,
            minorTicksPerInterval: 5,
            minorTickStyle: MinorTickStyle(
              lengthUnit: GaugeSizeUnit.logicalPixel,
              length: 8,
              color: Colors.grey.shade400,
            ),
            majorTickStyle: MajorTickStyle(
              lengthUnit: GaugeSizeUnit.logicalPixel,
              length: 16,
              color: Colors.grey.shade600,
            ),
            axisLineStyle: const AxisLineStyle(
              thicknessUnit: GaugeSizeUnit.factor,
              thickness: 0.2,
              // color: Colors.green,
              gradient: SweepGradient(
                colors: [
                  Color(0xFF101010),
                  Color(0xFF202020),
                  Color(0xFF434343),
                  Color(0xFF202020),
                  Color(0xFF101010),
                  Color(0xFF202020),
                  Color(0xFF434343),
                  Color(0xFF202020),
                  Color(0xFF101010),
                ],
              ),
            ),
            ranges: <GaugeRange>[
              GaugeRange(
                startValue: 0,
                endValue: 360,
                sizeUnit: GaugeSizeUnit.factor,
                endWidth: 0.16,
                startWidth: 0.16,
                color: Colors.grey.shade600,
                // gradient: SweepGradient(
                //   colors: [
                //     Colors.grey.shade800,
                //     Colors.grey.shade700,
                //     Colors.grey.shade600,
                //     Colors.grey.shade500,
                //     Colors.grey.shade600,
                //     Colors.grey.shade700,
                //     Colors.grey.shade800,
                //     Colors.grey.shade700,
                //     Colors.grey.shade600,
                //     Colors.grey.shade500,
                //     Colors.grey.shade400,
                //     Colors.grey.shade500,
                //     Colors.grey.shade600,
                //     Colors.grey.shade700,
                //     Colors.grey.shade800,
                //   ],
                // ),
              ),
            ],
            pointers: <GaugePointer>[
              NeedlePointer(
                value: pointerValue + 180,
                enableAnimation: true,
                needleStartWidth: 1,
                needleEndWidth: 10,
                gradient: LinearGradient(
                  colors: [
                    Colors.grey.shade300,
                    Colors.grey.shade500,
                    Colors.grey.shade700,
                    Colors.grey.shade900,
                  ]
                ),
                knobStyle: const KnobStyle(
                  borderWidth: 0.016,
                  borderColor: Colors.black,
                ),
              ),
              MarkerPointer(
                value: pointerValue,
                enableAnimation: true,
                markerType: MarkerType.text,
                text: 'N',
                textStyle: const GaugeTextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              MarkerPointer(
                value: pointerValue + 45,
                enableAnimation: true,
                markerType: MarkerType.text,
                text: 'NE',
                textStyle: const GaugeTextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              MarkerPointer(
                value: pointerValue + 90,
                enableAnimation: true,
                markerType: MarkerType.text,
                text: 'E',
                textStyle: const GaugeTextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              MarkerPointer(
                value: pointerValue + 135,
                enableAnimation: true,
                markerType: MarkerType.text,
                text: 'SE',
                textStyle: const GaugeTextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              MarkerPointer(
                value: pointerValue + 180,
                enableAnimation: true,
                markerType: MarkerType.text,
                text: 'S',
                textStyle: const GaugeTextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              MarkerPointer(
                value: pointerValue + 225,
                enableAnimation: true,
                markerType: MarkerType.text,
                text: 'SW',
                textStyle: const GaugeTextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              MarkerPointer(
                value: pointerValue + 270,
                enableAnimation: true,
                markerType: MarkerType.text,
                text: 'W',
                textStyle: const GaugeTextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              MarkerPointer(
                value: pointerValue + 315,
                enableAnimation: true,
                markerType: MarkerType.text,
                text: 'NW',
                textStyle: const GaugeTextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
            annotations: <GaugeAnnotation>[],
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  // Widget _buildManualReader() {
  //   return Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: Row(
  //       children: <Widget>[
  //         ElevatedButton(
  //           child: const Text('Read Value'),
  //           onPressed: () async {
  //             final CompassEvent tmp = await FlutterCompass.events!.first;
  //             setState(() {
  //               _lastRead = tmp;
  //               _lastReadAt = DateTime.now();
  //             });
  //           },
  //         ),
  //         Expanded(
  //           child: Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 Text(
  //                   '$_lastRead',
  //                   style: Theme.of(context).textTheme.caption,
  //                 ),
  //                 Text(
  //                   '$_lastReadAt',
  //                   style: Theme.of(context).textTheme.caption,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _buildPermissionSheet() {
  //   return Center(
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: <Widget>[
  //         const Text('Location Permission Required'),
  //         ElevatedButton(
  //           child: const Text('Request Permissions'),
  //           onPressed: () {
  //             Permission.locationWhenInUse.request().then((ignored) {
  //
  //             });
  //           },
  //         ),
  //         const SizedBox(height: 16),
  //         ElevatedButton(
  //           child: const Text('Open App Settings'),
  //           onPressed: () {
  //             openAppSettings().then((opened) {
  //               //
  //             });
  //           },
  //         )
  //       ],
  //     ),
  //   );
  // }
}
