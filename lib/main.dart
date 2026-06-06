import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'controllers/job_controller.dart';
import 'screens/job_dashboard.dart';
import 'screens/job_details_inspector.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const HireHubApp());
}

class HireHubApp extends StatelessWidget {
  const HireHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HireHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF6C5CE7),
          secondary: const Color(0xFFA29BFE),
          surface: const Color(0xFF161B22),
        ),
        useMaterial3: true,
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(JobController());
      }),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => JobDashboard(),
        ),
        GetPage(
          name: '/detail',
          page: () => JobDetailInspector(),
          transition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 350),
        ),
      ],
    );
  }
}
