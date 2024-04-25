import 'package:codepush_test/helper/devlog.dart';
import 'package:codepush_test/shorebirdPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

final shorebirdCodePush = ShorebirdCodePush();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) {
    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: HomeRoutePage(),
    );
  }
}

class HomeRoutePage extends StatefulWidget {
  const HomeRoutePage({super.key});

  @override
  State<HomeRoutePage> createState() => _HomeRoutePageState();
}

class _HomeRoutePageState extends State<HomeRoutePage> {
  @override
  void initState() {
    super.initState();
    shorebirdCodePush.currentPatchNumber().then(
      (value) {
        devLog("版本號測試", value.toString());
      },
    );
  }

  void _checkForUpdates() async {
    final isUpdateAvailable =
        await shorebirdCodePush.isNewPatchAvailableForDownload();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("有無新版本=> ${isUpdateAvailable.toString()}"),
        duration: const Duration(seconds: 5),
      ),
    );

    devLog("有無新版本", isUpdateAvailable.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shorebird Page"),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _checkForUpdates();
              },
              child: const Text("版本確認"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: const Text("重整畫面"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: const Text("CodePush"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const shorebirdPage(),
                  ),
                );
              },
              child: const Text("shorebirdPage"),
            ),
          ],
        ),
      ),
    );
  }
}
