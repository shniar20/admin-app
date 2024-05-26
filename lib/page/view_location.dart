import 'package:employee/models/emergency_model.dart';
import 'package:employee/page/component/emergency_card.dart';
import 'package:employee/page/component/side_drawer.dart';
import 'package:employee/page/detailed_location.dart';
import 'package:employee/services/emergency_services.dart';
import 'package:employee/store/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewLocation extends StatefulWidget {
  const ViewLocation({Key? key}) : super(key: key);

  @override
  State<ViewLocation> createState() => _ViewLocationState();
}

class _ViewLocationState extends State<ViewLocation> {
  late AdminProvider adminProvider;
  final EmergencyServices emergencyServices = EmergencyServices();
  List<Emergency> emergencies = [];
  bool loading = true;
  bool answered = false;
  bool? ambulanceAnswered;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    adminProvider = Provider.of<AdminProvider>(context, listen: false);

    if (adminProvider.facility!.department == 0) {
      ambulanceAnswered = false;
    }

    emergencyServices
        .getEmergencies(
            department: adminProvider.facility!.department,
            answered: answered,
            ambulanceAnswered: ambulanceAnswered)
        .then((value) {
      setState(() {
        emergencies = value;
        loading = false;
      });
    });
  }

  Future refresh() async {
    setState(() {
      loading = true;
    });
    emergencies = await emergencyServices.getEmergencies(
        department: adminProvider.facility?.department ?? -1,
        answered: answered,
        ambulanceAnswered: ambulanceAnswered);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            answered = !answered;
            refresh();
          },
          icon: const Icon(
            Icons.location_on,
          ),
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 110, 14, 7),
        title: Text(
          answered ? "وەڵام دراوەکان" : "ناونیشانە هاتووەکان",
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'rabar',
          ),
        ),
        centerTitle: true,
        actionsIconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      endDrawer: const SideDrawer(),
      body: loading
          ? const Center(
              child: SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await refresh();
              },
              child: emergencies.isNotEmpty
                  ? ListView.separated(
                      padding: const EdgeInsets.all(10.0),
                      itemBuilder: (context, index) {
                        String department = "";
                        switch (emergencies[index].department) {
                          case 0:
                            department = "ئەمبوڵانس";
                            break;
                          case 1:
                            department = "ئاگرکوژێنەوە";
                            break;
                          case 2:
                            department = "هاتووچۆ";
                            break;
                          case 10:
                            department = "ئەمبولانس و ئاگرکوژێنەوە";
                            break;
                          case 20:
                            department = "ئەمبوڵانس و هاتووچۆ";
                            break;
                        }

                        return EmergencyCard(
                          adminDepartment: adminProvider.facility!.department,
                          emergency: emergencies[index],
                          department: department,
                          onPressed: () {
                            Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailedLocation(
                                  adminProvider: adminProvider,
                                  emergency: emergencies[index],
                                  department: department,
                                  refresh: refresh,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10.0),
                      itemCount: emergencies.length,
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) => ListView(
                        children: [
                          Expanded(
                            child: Container(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: Center(
                                child: Text(
                                  "هیچ فریاکەوتنێک داوا نەکراوە",
                                  style: TextStyle(
                                    fontFamily: 'rabar',
                                    fontSize: 24.0,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
      // body: ListView(
      //   padding: const EdgeInsets.all(10.0),
      //   children: const [
      //     EmergencyCard(),
      //     EmergencyCard(),
      //     EmergencyCard(),
      //     EmergencyCard(),
      //   ],
      // ),
    );
  }
}
