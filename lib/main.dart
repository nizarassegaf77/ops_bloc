import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bottom_navigation_bloc/repositories/repositories.dart';
import 'package:bottom_navigation_bloc/blocs/bottom_navigation/bottom_navigation.dart';
import 'package:bottom_navigation_bloc/ui/app_screen.dart';

import 'repositories/martbox_repository.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Stickmartops',
        theme: new ThemeData(
            primarySwatch: Colors.purple,
            primaryColor: Colors.purple,
            primaryColorDark: Colors.purple[800] ,
            accentColor: Colors.yellow[600]),
        home: BlocProvider<BottomNavigationBloc>(
          builder: (context) => BottomNavigationBloc(
            firstPageRepository: FirstPageRepository(),
            secondPageRepository: SecondPageRepository(),
            martboxPageRepository: MartboxPageRepository(),
          )..dispatch(AppStarted()),
          child: AppScreen(),
        ));
  }
}
