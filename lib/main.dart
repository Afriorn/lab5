import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab5/cubbit/acceleration_cubbit.dart';
import 'package:lab5/cubbit/history_cubbit.dart';
import 'package:lab5/model/database_help.dart';
import 'package:lab5/screen/acceleration_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AccelerationCubit(databaseHelper: DatabaseHelper.instance),
        ),
        BlocProvider(
          create: (context) => HistoryCubit(databaseHelper: DatabaseHelper.instance),
        ),
      ],
      child: MaterialApp(
        title: 'Расчет ускорения',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AccelerationScreen(),
      ),
    );
  }
}

