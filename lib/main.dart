import 'imports.dart';

void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Storage.instance();

  runApp(const BusTrackerApp());
}

class BusTrackerApp extends StatelessWidget {
  const BusTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<dynamic>(
        future: Storage.get("loggedIn"),
        builder: (context, _loggedIn) {
          bool? _value = _loggedIn.data as bool?;

          if(_value ?? false) {
            return const HomeView();
          } else {
            return const IntroView();
          }
        }
      ),
    );
  }
}
