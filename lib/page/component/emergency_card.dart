import 'package:employee/models/emergency_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class EmergencyCard extends StatelessWidget {
  final int adminDepartment;
  final Emergency emergency;
  final String department;
  final VoidCallback onPressed;

  const EmergencyCard({
    super.key,
    required this.adminDepartment,
    required this.emergency,
    required this.department,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: adminDepartment == 0 &&
                (emergency.department == 10 || emergency.department == 20)
            ? emergency.ambulanceAnswered!
                ? const Color(0xFFDAF0DB)
                : const Color(0xFFF0DADA)
            : emergency.answered
                ? const Color(0xFFDAF0DB)
                : const Color(0xFFF0DADA),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        textDirection: TextDirection.rtl,
        children: [
          Text(
            "بەشی $department",
            style: const TextStyle(
              fontFamily: 'rabar',
              fontSize: 20.0,
            ),
            textAlign: TextAlign.end,
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  emergency.needsAmbulance
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.local_shipping,
                              color: Color(0xFF6E0000),
                              size: 28.0,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "${emergency.numberOfAmbulances}",
                              style: const TextStyle(
                                fontFamily: 'rabar',
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  Text(
                    intl.DateFormat("hh:mm a - dd/MM")
                        .format(emergency.createdAt)
                        .toString(),
                    style: const TextStyle(
                      fontFamily: 'rabar',
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "نێردراوە لەلایەن:",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'rabar',
                      fontSize: 16.0,
                      color: Color.fromARGB(255, 91, 91, 91),
                    ),
                  ),
                  Text(
                    emergency.user?.name ?? "",
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontFamily: 'rabar',
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    emergency.user?.phoneNumber ?? "",
                    // textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontFamily: 'rabar',
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: adminDepartment == 0 &&
                      (emergency.department == 10 || emergency.department == 20)
                  ? emergency.ambulanceAnswered!
                      ? const Color(0xFF006E00)
                      : const Color(0xFF6E0000)
                  : emergency.answered
                      ? const Color(0xFF006E00)
                      : const Color(0xFF6E0000),
            ),
            child: const Text(
              "پیشاندان",
              style: TextStyle(
                fontFamily: 'rabar',
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
