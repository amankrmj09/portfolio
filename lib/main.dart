import 'package:portfolio/infrastructure/theme/dark_theme.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'presentation/info.fetch.controller.dart';
import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    Get.putAsync(() async => InfoFetchController());
    var initialRoute = await Routes.initialRoute;
    runApp(Main(initialRoute));
  } catch (e, stack) {
    runApp(ErrorApp(error: e.toString(), stack: stack.toString()));
  }
}

class ErrorApp extends StatelessWidget {
  final String error;
  final String stack;

  const ErrorApp({required this.error, required this.stack, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Text('Startup error: $error\n$stack'),
          ),
        ),
      ),
    );
  }
}

class Main extends StatelessWidget {
  final String initialRoute;

  const Main(this.initialRoute, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,

      getPages: Nav.routes,
      theme: kDarkTheme,
    );
  }
}
