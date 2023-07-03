import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:using_firebase/app_bloc_observer.dart';
import 'package:using_firebase/features/database/database_bloc.dart';
import 'package:using_firebase/firebase_options.dart';
import 'package:using_firebase/repository/authentication_repository_impl.dart';
import 'package:using_firebase/bloc_navigate.dart';
import 'package:using_firebase/features/authentication/authentication_bloc.dart';
import 'package:using_firebase/features/form_validation/form_bloc.dart';
import 'package:using_firebase/repository/database_repository_impl.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return
      // BlocOverrides.runZoned(
      // () {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>   AuthenticationBloc(AuthenticationRepositoryImpl())
              ..add(AuthenticationStarted()),
            ),
            BlocProvider(
              create: (context) => FormBloc(
                  AuthenticationRepositoryImpl(), DatabaseRepositoryImpl()),
            ),
            //
            BlocProvider(
              create: (context) => DatabaseBloc(DatabaseRepositoryImpl()),
            )
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.blueAccent
              )
            ),
            home: const BlocNavigate(),
          )
        );
    //   },
    //   blocObserver: AppBlocObserver(),
    // );
  }
}
