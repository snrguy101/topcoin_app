import 'package:crypto_price/blocks/crypto/crypto_bloc.dart';
import 'package:crypto_price/respositories/crypto_respository.dart';
import 'package:crypto_price/screens/home_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  EquatableConfig.stringify = kDebugMode;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => CryptoRespository(),
      child: MaterialApp(
        title: 'Crypto App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.tealAccent,
        ),
        home: BlocProvider(
          create: (context) => CryptoBloc(
            cryptoRespository: context.read<CryptoRespository>(),
          )..add(AppStarted()),
          child: HomeScreen(),
        ),
      ),
    );
  }
}
