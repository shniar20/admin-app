import 'package:employee/models/emergency_model.dart';
import 'package:employee/services/emergency_services.dart';
import 'package:employee/store/admin_provider.dart';
import 'package:employee/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' as intl;

class DetailedLocation extends StatefulWidget {
  final AdminProvider adminProvider;
  final Emergency emergency;
  final String department;
  final Function refresh;
  const DetailedLocation({
    super.key,
    required this.adminProvider,
    required this.emergency,
    required this.department,
    required this.refresh,
  });

  @override
  State<DetailedLocation> createState() => _DetailedLocationState();
}

class _DetailedLocationState extends State<DetailedLocation> {
  final EmergencyServices emergencyServices = EmergencyServices();
  late GoogleMapController _controller;
  Marker? _marker;
  Position? currentPosition;

  @override
  void initState() {
    super.initState();

    _marker = Marker(
      markerId: const MarkerId("marker"),
      position: LatLng(
        double.parse(widget.emergency.location.latitude),
        double.parse(widget.emergency.location.longitude),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        double.parse(widget.emergency.location.latitude),
                        double.parse(widget.emergency.location.longitude),
                      ), // Coordinates for a location in Iraq
                      zoom: 14,
                    ),
                    cameraTargetBounds: CameraTargetBounds(
                      LatLngBounds(
                        southwest: const LatLng(
                          35.20873765977967,
                          42.33197249772141,
                        ),
                        northeast: const LatLng(
                          37.09366008380238,
                          46.15521300554078,
                        ),
                      ),
                    ),
                    minMaxZoomPreference: const MinMaxZoomPreference(7, 18),
                    mapToolbarEnabled: false,
                    layoutDirection: TextDirection.rtl,
                    onMapCreated: (controller) {
                      _controller = controller;
                    },
                    markers: <Marker>{_marker!},
                  ),
                  Positioned(
                    top: 14.0,
                    left: 14.0,
                    child: FloatingActionButton(
                      heroTag: "back",
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      shape: const CircleBorder(),
                      backgroundColor: Colors.white,
                      mini: true,
                      child: const Icon(
                        Icons.chevron_left,
                        color: Color(0xFF6E0000),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(14.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.department,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontFamily: 'rabar',
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(height: 14.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          widget.emergency.user?.name ?? "",
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            fontFamily: 'rabar',
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          widget.emergency.user?.phoneNumber ?? "",
                          style: const TextStyle(
                            fontFamily: 'rabar',
                            fontSize: 16.0,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 14.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      textDirection: TextDirection.rtl,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          textDirection: TextDirection.rtl,
                          children: [
                            Row(
                              textDirection: TextDirection.rtl,
                              children: [
                                const Text(
                                  "ژمارەی ئەمبوڵانس:",
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontFamily: 'rabar',
                                    fontSize: 16.0,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "${widget.emergency.numberOfAmbulances}",
                                  style: const TextStyle(
                                    fontFamily: 'rabar',
                                    fontSize: 16.0,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.local_shipping,
                                  color: Color(0xFF6E0000),
                                  size: 28.0,
                                ),
                              ],
                            ),
                            Text(
                              intl.DateFormat("hh:mm a - dd/MM")
                                  .format(widget.emergency.createdAt)
                                  .toString(),
                              style: const TextStyle(
                                fontFamily: 'rabar',
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            FloatingActionButton(
                              heroTag: "approve",
                              onPressed: widget.adminProvider.facility!
                                              .department ==
                                          0 &&
                                      (widget.emergency.department == 10 ||
                                          widget.emergency.department == 20)
                                  ? !widget.emergency.ambulanceAnswered!
                                      ? () async {
                                          bool result = await emergencyServices
                                              .approveEmergency(
                                                  emergency: widget.emergency,
                                                  withAmbulance: true);

                                          if (!result && context.mounted) {
                                            showSnackBar(
                                              context,
                                              "Couldn't approve request",
                                            );

                                            return;
                                          }

                                          if (context.mounted) {
                                            Navigator.pop(context);
                                            await widget.refresh();
                                          }
                                        }
                                      : null
                                  : !widget.emergency.answered
                                      ? () async {
                                          bool result = await emergencyServices
                                              .approveEmergency(
                                                  emergency: widget.emergency);

                                          if (!result && context.mounted) {
                                            showSnackBar(
                                              context,
                                              "Couldn't approve request",
                                            );

                                            return;
                                          }

                                          if (context.mounted) {
                                            Navigator.pop(context);
                                            await widget.refresh();
                                          }
                                        }
                                      : null,
                              mini: true,
                              disabledElevation: 0,
                              backgroundColor:
                                  widget.adminProvider.facility!.department ==
                                              0 &&
                                          (widget.emergency.department == 10 ||
                                              widget.emergency.department == 20)
                                      ? widget.emergency.ambulanceAnswered!
                                          ? const Color(0xFF646464)
                                          : const Color(0xFF6E0000)
                                      : widget.emergency.answered
                                          ? const Color(0xFF646464)
                                          : const Color(0xFF6E0000),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            FloatingActionButton(
                              heroTag: "reject",
                              onPressed: widget.adminProvider.facility!
                                              .department ==
                                          0 &&
                                      (widget.emergency.department == 10 ||
                                          widget.emergency.department == 20)
                                  ? !widget.emergency.ambulanceAnswered!
                                      ? () async {
                                          bool result = await emergencyServices
                                              .rejectEmergency(
                                                  widget.emergency);

                                          if (!result && context.mounted) {
                                            showSnackBar(
                                              context,
                                              "Couldn't reject request",
                                            );

                                            return;
                                          }

                                          if (context.mounted) {
                                            Navigator.pop(context);
                                            await widget.refresh();
                                          }
                                        }
                                      : null
                                  : !widget.emergency.answered
                                      ? () async {
                                          bool result = await emergencyServices
                                              .rejectEmergency(
                                                  widget.emergency);

                                          if (!result && context.mounted) {
                                            showSnackBar(
                                              context,
                                              "Couldn't reject request",
                                            );

                                            return;
                                          }

                                          if (context.mounted) {
                                            Navigator.pop(context);
                                            await widget.refresh();
                                          }
                                        }
                                      : null,
                              mini: true,
                              disabledElevation: 0,
                              backgroundColor:
                                  widget.adminProvider.facility!.department ==
                                              0 &&
                                          (widget.emergency.department == 10 ||
                                              widget.emergency.department == 20)
                                      ? widget.emergency.ambulanceAnswered!
                                          ? const Color(0xFFE7E7E7)
                                          : const Color(0xFFF0DADA)
                                      : widget.emergency.answered
                                          ? const Color(0xFFE7E7E7)
                                          : const Color(0xFFF0DADA),
                              child: Icon(
                                Icons.close,
                                color: widget.adminProvider.facility!
                                                .department ==
                                            0 &&
                                        (widget.emergency.department == 10 ||
                                            widget.emergency.department == 20)
                                    ? widget.emergency.ambulanceAnswered!
                                        ? const Color(0xFF646464)
                                        : const Color(0xFF6E0000)
                                    : widget.emergency.answered
                                        ? const Color(0xFF646464)
                                        : const Color(0xFF6E0000),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
