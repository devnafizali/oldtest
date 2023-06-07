import 'package:battery_percentage/screens/discovery_page.dart';
import 'package:battery_percentage/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Battery()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: firebaseAuth.currentUser == null ? 'login' : 'discovery',
      routes: {
        'login': (context) => Loginpage(),
        'discovery': ((context) => DiscoveryPage(firebaseAuth.currentUser!.email!))
      },
    );
  }
}

class Battery with ChangeNotifier {
  String _percent = '0%';
  bool _listening = false;
  String get percent => _percent;
  bool get listening => _listening;
  void increment(String value) {
    _listening = true;

    if (isNumaric(value)) {
      _percent = value.replaceAll('\n', '');
      notifyListeners();
    }
  }

  bool isNumaric(value) {
    try {
      double.parse(value);
      return true;
    } catch (e) {
      return false;
    }
  }

  String getBatteryPercent() {
    return _percent;
  }

  void stopIncrement() {
    _listening = false;
    notifyListeners();
  }
}
