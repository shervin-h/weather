import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:weather/core/params/forecast_params.dart';
import 'package:weather/core/utils/polyline_extension.dart';
import 'package:weather/core/widgets/custom_widgets.dart';
import 'package:weather/core/widgets/loading_widget.dart';
import 'package:weather/features/feature_map/data/model/neshan_response_model.dart';
import 'package:weather/features/feature_map/domain/entities/neshan_response_entity.dart';
import 'package:weather/features/feature_map/domain/use_cases/get_routes_use_case.dart';
import 'package:weather/features/feature_map/domain/use_cases/get_user_location_use_case.dart';
import 'package:weather/features/feature_map/domain/use_cases/get_ways_use_case.dart';
import 'package:weather/features/feature_map/presentation/bloc/change_location_status.dart';
import 'package:weather/features/feature_map/presentation/bloc/get_location_status.dart';
import 'package:weather/features/feature_map/presentation/bloc/get_ways_status.dart';
import 'package:weather/features/feature_map/presentation/bloc/map_bloc.dart';

import '../../../../core/resources/data_state.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  static const String routeName = '/map-screen';

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with AutomaticKeepAliveClientMixin{
  late final MapController _mapController;


  void showPositionInfo(BuildContext context, LatLng position, LatLng origin) {
    showBottomSheet(
      context: context,
      backgroundColor: context.theme.colorScheme.background,
      builder: (context) {
        return FutureBuilder<DataState<NeshanResponseEntity>>(
          future: GetRoutesUseCase()(NeshanRouteParams(origin: origin, destination: position)),  // DataState<NeshanResponseEntity>
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                width: context.width,
                height: context.height * 0.24,
                child: Center(
                  child: CupertinoActivityIndicator(color: context.theme.colorScheme.primary, radius: 12),
                ),
              );
            } else {
              if (snapshot.hasData && snapshot.data != null) {
                final dataState = snapshot.data!;
                if (dataState is DataFailed) {
                  return SizedBox(
                    width: context.width,
                    height: context.height * 0.24,
                    child: Center(
                      child: Text(
                        dataState.error ?? '',
                        style: context.textTheme.bodyText2!.copyWith(color: context.theme.errorColor),
                      ),
                    ),
                  );
                }
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    width: context.width,
                    height: context.height * 0.24,
                    child: Column(
                      children: [
                        Text(
                          '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}',
                          style: context.textTheme.bodyText1,
                          textAlign: TextAlign.end,
                          textDirection: TextDirection.ltr,

                        ),
                        const SizedBox(height: 4),
                        FittedBox(
                          child: Text(
                            '${dataState.data?.routes?[0].legs?[0].summary}',
                            style: context.textTheme.bodyText1,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const SizedBox(height: 4),
                        FittedBox(
                          child: Text(
                            '${dataState.data?.routes?[0].legs?[0].distance?.text}  -  ${dataState.data?.routes?[0].legs?[0].duration?.text}',
                            style: context.textTheme.bodyText2,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (dataState.data != null && dataState.data!.routes != null) {
                                      BlocProvider.of<MapBloc>(context).add(GetWaysEvent(neshanResponseEntity: dataState.data!));
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: const Text('مسیر ها'),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('بستن'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return SizedBox(
                  width: context.width,
                  height: context.height * 0.24,
                  child: Center(
                    child: lottie.Lottie.asset('assets/lottie/error.json'),
                  ),
                );
              } else {
                return Container();
              }
            }
          },
        );
      },
    );
  }

  PolylineLayer _getPolyLineLayer (List<List<LatLng>> ways) {
    return PolylineLayer(
      polylines: [
        for (int i=0; i < ways.length; i++)
          Polyline(
            points: ways[i],
            strokeWidth: 6,
            color: (i == 0)
                ? Colors.blue.withOpacity(0.9)
                : Colors.deepOrange.withOpacity(0.9),
          )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    BlocProvider.of<MapBloc>(context).add(GetLocationEvent());

    // Timer.periodic(
    //   const Duration(seconds: 10),
    //   (timer) {
    //     BlocProvider.of<MapBloc>(context).add(GetLocationEvent());
    //   },
    // );
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GetUserLocationUseCase()().then((DataState<LocationData> dataState) {
            if (dataState is DataSuccess && dataState.data != null) {
              _mapController.move(
                LatLng(dataState.data!.latitude!, dataState.data!.longitude!),
                16,
              );
            }
          });
        },
        child: const Icon(CupertinoIcons.scope),
      ),
      body: SafeArea(
        child: BlocConsumer<MapBloc, MapState>(
          listenWhen: (previous, current) {
            if (previous.getLocationStatus == current.getLocationStatus) {
              return false;
            }
            return true;
          },
          listener: (context, state) {},
          buildWhen: (previous, current) {
            if (previous.getLocationStatus == current.getLocationStatus) {
              return false;
            }
            return true;
          },
          builder: (context, state) {
            if (state.getLocationStatus is GetLocationLoadingStatus) {
              return Center(
                child: lottie.Lottie.asset(
                  'assets/lottie/map_location.json',
                  width: context.width * 0.4,
                  height: context.width * 0.4,
                ),
              );
            } else if (state.getLocationStatus is GetLocationCompletedStatus) {
              final status = state.getLocationStatus as GetLocationCompletedStatus;
              final origin = LatLng(status.locationData.latitude!, status.locationData.longitude!);

              return BlocConsumer<MapBloc, MapState>(
                listener: (context, state) {},
                buildWhen: (previous, current) {
                  if (previous.getWaysStatus == current.getWaysStatus) {
                    return false;
                  }
                  return true;
                },
                builder: (context, state) {
                  if (state.getWaysStatus is GetWaysCompletedStatus) {
                    var ways = (state.getWaysStatus as GetWaysCompletedStatus).ways;
                    return FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        bounds: LatLngBounds(
                          origin,
                          (state.selectedLocationStatus as SelectedLocationCompletedStatus).latLng,
                        ),
                        boundsOptions: const FitBoundsOptions(padding: EdgeInsets.all(16)),
                        center: origin,
                        zoom: 14,
                        onLongPress: (tapPosition, selectedLatLng) {
                          BlocProvider.of<MapBloc>(context).add(SelectedLocationEvent(latLng: selectedLatLng));

                          /// under
                          showPositionInfo(context, selectedLatLng, origin);
                        },
                        onTap: (tapPosition, latLng) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              elevation: 16,
                              margin: const EdgeInsets.all(16),
                              content: Text('${latLng.latitude.toStringAsFixed(6)}, ${latLng.longitude.toStringAsFixed(6)}'),
                            )
                          );
                        }
                      ),
                      children: [
                        TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 48,
                              height: 48,
                              point: origin,
                              builder: (context) {
                                return lottie.Lottie.asset(
                                  'assets/lottie/map_location.json',
                                  width: 48,
                                  height: 48,
                                );
                              },
                            ),
                          ],
                        ),
                        BlocConsumer<MapBloc, MapState>(
                          buildWhen: (previous, current) {
                            if (previous.selectedLocationStatus == current.selectedLocationStatus) {
                              return false;
                            }
                            return true;
                          },
                          builder: (context, state) {
                            if (state.selectedLocationStatus is SelectedLocationCompletedStatus) {
                              final status = state.selectedLocationStatus as SelectedLocationCompletedStatus;

                              // selected or destination location
                              return MarkerLayer(
                                markers: [
                                  Marker(
                                    width: 48,
                                    height: 48,
                                    point: status.latLng,
                                    builder: (context) {
                                      return lottie.Lottie.asset(
                                        'assets/lottie/destination_location.json',
                                        width: 48,
                                        height: 48,
                                      );
                                    },
                                  ),
                                ],
                              );
                            }
                            return Container();
                          },
                          listener: (context, state) {},
                        ),
                        if (ways.isNotEmpty)
                          _getPolyLineLayer(ways),
                      ],
                    );
                  }
                  return FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      center: origin,
                      zoom: 16,
                      onLongPress: (tapPosition, selectedLatLng) {
                        BlocProvider.of<MapBloc>(context).add(SelectedLocationEvent(latLng: selectedLatLng));

                        /// under
                        showPositionInfo(context, selectedLatLng, origin);
                      },
                      onTap: (tapPosition, latLng) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            elevation: 16,
                            margin: const EdgeInsets.all(16),
                            content: Text('${latLng.latitude.toStringAsFixed(6)}, ${latLng.longitude.toStringAsFixed(6)}'),
                          )
                        );
                      }
                    ),
                    children: [
                      TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 48,
                            height: 48,
                            point: origin,
                            builder: (context) {
                              return lottie.Lottie.asset(
                                'assets/lottie/map_location.json',
                                width: 48,
                                height: 48,
                              );
                            },
                          ),
                        ],
                      ),
                      BlocConsumer<MapBloc, MapState>(
                        buildWhen: (previous, current) {
                          if (previous.selectedLocationStatus == current.selectedLocationStatus) {
                            return false;
                          }
                          return true;
                        },
                        builder: (context, state) {
                          if (state.selectedLocationStatus is SelectedLocationCompletedStatus) {
                            final status = state.selectedLocationStatus as SelectedLocationCompletedStatus;

                            // selected or destination location
                            return MarkerLayer(
                              markers: [
                                Marker(
                                  width: 48,
                                  height: 48,
                                  point: status.latLng,
                                  builder: (context) {
                                    return lottie.Lottie.asset(
                                      'assets/lottie/destination_location.json',
                                      width: 48,
                                      height: 48,
                                    );
                                  },
                                ),
                              ],
                            );
                          }
                          return Container();
                        },
                        listener: (context, state) {},
                      ),
                    ],
                  );
                },
              );

            } else if (state.getLocationStatus is GetLocationErrorStatus) {
              final errorMessage = (state.getLocationStatus as GetLocationErrorStatus).errorMessage;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    lottie.Lottie.asset(
                      'assets/lottie/error.json',
                      width: context.width * 0.4,
                      height: context.width * 0.4,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorMessage,
                      style: context.textTheme.bodyText2!.copyWith(color: context.theme.errorColor),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
