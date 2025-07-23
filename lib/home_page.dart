import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:web_app/utils/PostureMonitorService.dart';
import 'package:provider/provider.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final monitorService = Provider.of<PostureMonitorService>(context);
    final status = monitorService.status;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FitAI Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Posture Status:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),

            Text(
              status,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: status == 'Good'
                    ? Colors.green
                    : status == 'Slouching'
                    ? Colors.red
                    : Colors.grey,
              ),
            ),

            const SizedBox(height: 10),

            /// ✅ Show real-time tilt angle here
            Text(
              "Tilt Angle: ${monitorService.angle.toStringAsFixed(1)}°",
              style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                monitorService.toggleMonitoring();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: monitorService.isMonitoring
                    ? Colors.red
                    : Colors.green,
                minimumSize: const Size(160, 45),
              ),
              child: Text(
                monitorService.isMonitoring ? 'Stop Monitoring' : 'Start Monitoring',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}