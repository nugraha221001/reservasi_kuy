import 'package:flutter/material.dart';

import 'src/presentation/utils/routes/route_app.dart';

class Apps extends StatefulWidget {
  const Apps({super.key});

  @override
  State<Apps> createState() => _AppsState();
}

class _AppsState extends State<Apps> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp.router(
        routerConfig: routeApp,
        theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFFFFFFF)),
      ),
    );
  }
}
