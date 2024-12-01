import 'dart:math';
import 'dart:io';
import 'package:ecbee_task/Dashboard/List.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jiffy/jiffy.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:random_string/random_string.dart';

import '../Auth/Auth.dart';
import 'DashServi.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Position? currentlocation;
  List<Placemark>? placemarks;
  int id = 0;
  var ipAddress;
  bool loading = false;
  var loginTime;
  Future<String?> getIPAddress() async {
    try {
      for (var interface in await NetworkInterface.list()) {
        for (var address in interface.addresses) {
          if (address.type == InternetAddressType.IPv4) {
            return address.address;
          }
        }
      }
    } catch (e) {
      print("Failed to get IP address: $e");
    }
    return null;
  }

// Future<Position> getLocation() async {
//     final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!isServiceEnabled) {
//       print("Location services are disabled. Enable them in settings.");
//       // LocationPermission permission = await Geolocator.requestPermission();
//       LocationPermission permission = await Geolocator.checkPermission();
//       return Future.error(
//           'Location services are disabled. Enable them in settings.');
//     }
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         print("Location permission denied.");
//         return Future.error('Location permission denied.');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       print("Location permission permanently denied. Open settings.");
//       return Future.error('Location permission denied.');
//     }

//     print("Location permission granted.");
//     return Geolocator.getCurrentPosition();
//   }

  Future<Position> getLocation() async {
    // Check the current permission status
    LocationPermission permission = await Geolocator.checkPermission();

    // If permission is denied, request permission
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permission denied.");
        return Future.error('Location permission denied.');
        ;
      }
    }

    // If permission is permanently denied, handle it by directing to settings
    if (permission == LocationPermission.deniedForever) {
      print("Location permission permanently denied.");
      // Optionally, open settings to manually grant permission
      await Geolocator.openAppSettings();
      return Future.error('Location permission denied.');
    }

    // Permission is granted
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      print("Location permission granted.");
      return Geolocator.getCurrentPosition();
    }
    return Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    getallvalue();
    super.initState();
  }

  getallvalue() async {
    loginTime = DateTime.now();
    Random random = Random();
    id = random.nextInt(1000);
    try {
      currentlocation = await getLocation();
      print('Current Location is $currentlocation');
      placemarks = await placemarkFromCoordinates(
          currentlocation?.latitude ?? 37.4219,
          currentlocation?.longitude ?? -122.084);
    } catch (e) {
      print('Current Location error is $e');
      loading = true;
      placemarks = null;
      setState(() {});
    }

    ipAddress = await getIPAddress();
    loading = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              color: const Color.fromARGB(255, 10, 60, 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 100, right: 20),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const Authpage(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: const Text(
                            "Logout",
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(35),
                                topRight: Radius.circular(35))),
                        alignment: AlignmentDirectional.bottomEnd,
                        height: MediaQuery.of(context).size.height - 200,
                        child: Center(
                            child: loading
                                ? Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        // height: 120,
                                        // width: 120,
                                        color: Colors.white,
                                        child: QrImageView(
                                          data: id.toString(),
                                          version: QrVersions.auto,
                                          size: 200.0,
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          const Text(
                                            "Generated Number",
                                            style: TextStyle(
                                                fontSize: 24,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w200),
                                          ),
                                          Text(
                                            id.toString(),
                                            style: const TextStyle(
                                                fontSize: 24,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w200),
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            height: 60,
                                            width: 350,
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Colors.white)),
                                            child: Center(
                                              child: Text(
                                                "Last Login at ${Jiffy(loginTime).format('hh:mm a')}",
                                                style: const TextStyle(
                                                    fontSize: 24,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w200),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              print(
                                                  "Date is --------- $loginTime");
                                              var req = {
                                                'location': placemarks == null
                                                    ? "Location unavailable"
                                                    : placemarks![0].locality,
                                                'time': Jiffy(loginTime)
                                                    .format('hh:mm a'),
                                                'id': id.toString(),
                                                "ipaddress":
                                                    ipAddress.toString(),
                                                'date': loginTime.toString()
                                              };
                                              await FirebaseData.adddata(
                                                  id.toString(), req);

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginList()),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.grey[
                                                  800], // Background color
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 90, vertical: 10),
                                              child: Text(
                                                "Save",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 28,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                : const CircularProgressIndicator(
                                    color: Colors.white,
                                  )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 140,
                  ),
                  child: Container(
                    height: 40,
                    width: 120,
                    decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: const Center(
                        child: Text(
                      "PLUGIN",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
