import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth_screens/login_screen.dart';
import 'screens/auth_screens/register_screen.dart';
import 'screens/auth_screens/otp_screen.dart';
import 'screens/user_screens/client_dashboard.dart';
import 'screens/user_screens/worker_dashboard.dart';
import 'screens/user_screens/create_job_screen.dart';
import 'screens/user_screens/job_details_screen.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Marketplace App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/otp': (context) => const OTPScreen(),
          '/client-dashboard': (context) => const ClientDashboard(),
          '/worker-dashboard': (context) => const WorkerDashboard(),
          '/create-job': (context) => const CreateJobScreen(),
          '/job-details': (context) {
            final args = ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>;
            return JobDetailsScreen(
              jobId: args['jobId'],
              title: args['title'],
              description: args['description'],
              category: args['category'],
              budget: args['budget'],
              clientName: args['clientName'],
            );
          },
        },
      ),
    );
  }
}
