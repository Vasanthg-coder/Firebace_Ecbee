import 'package:ecbee_task/Auth/Auth.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'DashModel.dart';
import 'DashServi.dart';
import 'Dashboard.dart';

class LoginList extends StatefulWidget {
  const LoginList({super.key});

  @override
  State<LoginList> createState() => _LoginListState();
}

class _LoginListState extends State<LoginList> {
  Stream<List<Data>>? data;
  bool loading = false;
  int tabindex = 0;
  @override
  void initState() {
    getdata();
    super.initState();
  }

  getdata() async {
    data = FirebaseData().getdata();
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 100, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          iconSize: 20,
                          color: Colors.white,
                          icon: const Icon(
                            Icons.arrow_back_ios_new_outlined,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        InkWell(
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
                      ],
                    ),
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
                        child: Column(
                          children: [
                            StreamBuilder(
                                stream: data,
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text('Error: ${snapshot.error}'),
                                    );
                                  }
                                  if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Center(
                                      child: Text('No data available'),
                                    );
                                  }
                                  final datas = snapshot.data!;
                                  List todaydata = [];
                                  List yesterdaydata = [];
                                  List olderdata = [];

                                  // Current date
                                  DateTime now = DateTime.now();
                                  DateTime todayStart =
                                      DateTime(now.year, now.month, now.day);
                                  DateTime yesterdayStart = todayStart
                                      .subtract(const Duration(days: 1));

                                  // Categorize the data
                                  for (var item in datas) {
                                    // Assuming the item has a date field as a string
                                    print("dateeeeeeeeeeeee ${item.date}");
                                    DateTime itemDate = DateTime.parse(item.date
                                        .toString()); // Adjust key as per your data structure

                                    if (itemDate.isAfter(todayStart)) {
                                      todaydata.add(item);
                                    } else if (itemDate
                                        .isAfter(yesterdayStart)) {
                                      yesterdaydata.add(item);
                                    } else {
                                      olderdata.add(item);
                                    }
                                  }
                                  print(
                                      "dateeeeeeeeeeeee is ${todaydata[0].date}");
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      tabindex = 0;
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color: tabindex == 0
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .transparent))),
                                                    child: const Center(
                                                      child: Text(
                                                        "Today",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      tabindex = 1;
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color: tabindex == 1
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .transparent))),
                                                    child: const Center(
                                                      child: Text(
                                                        "Yesterday",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      tabindex = 2;
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color: tabindex == 2
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .transparent))),
                                                    child: const Center(
                                                      child: Text(
                                                        "Older",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                300,
                                            child: Cards(
                                              datas: tabindex == 0
                                                  ? todaydata
                                                  : tabindex == 1
                                                      ? yesterdaydata
                                                      : olderdata,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        ),
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
                      "Last Login",
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

class Cards extends StatefulWidget {
  const Cards({super.key, this.datas});
  final datas;
  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  @override
  Widget build(BuildContext context) {
    return widget.datas.isEmpty
        ? const Center(
            child: Text(
              "No Data Found",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.only(top: 20),
            itemCount: widget.datas.length,
            itemBuilder: (context, index) {
              final data = widget.datas[index];
              print("Date is ${data.date}");
              return Card(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.time,
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w200),
                          ),
                          Text(
                            "IP : ${data.ipaddress}",
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w200),
                          ),
                          Text(
                            data.location.toString().toUpperCase(),
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w200),
                          ),
                        ],
                      ),
                      Container(
                        // height: 120,
                        // width: 120,
                        color: Colors.white,
                        child: QrImageView(
                          data: data.id,
                          version: QrVersions.auto,
                          size: 100.0,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
  }
}
