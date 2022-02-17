import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Platform Channel Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(title: 'Battery Level'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // Client and Host are connected through the below channel name passed in
  // channel constructor
  static const platform = MethodChannel('battery_level.triconinfotech.com/battery');

  String _batteryLevel = 'Unknown battery level.';
  String _batteryStatus = 'Unknown battery status.';

  // invoking method on method channel to fetch battery level
  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}.'";
    }
    setState(() {
      _batteryLevel = batteryLevel;
    });
  }
  
  Future<void> _getBatteryStatus() async {
    String batteryStatus;
    try {
      final bool result = await platform.invokeMethod('getBatteryStatus');
      if (result == true) {
        batteryStatus = 'Battery is charging.';
      } else {
        batteryStatus = 'Battery is not charging.';
      }
    } on PlatformException catch (e) {
      batteryStatus = "Failed to get battery status: '${e.message}.'";
    }
    setState(() {
      _batteryStatus = batteryStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _getBatteryLevel,
              child: const Text('Get Battery Level'),
            ),
            const Icon(Icons.battery_full),
            Text(_batteryLevel),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _getBatteryStatus,
              child: const Text('Get Battery Status'),
            ),
            const Icon(Icons.battery_charging_full),
            Text(_batteryStatus),
          ],
        ),
      ),
    );
  }
}
