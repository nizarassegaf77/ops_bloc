import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bottom_navigation_bloc/blocs/bottom_navigation/bottom_navigation.dart';
import 'package:bottom_navigation_bloc/ui/pages/pages.dart';

import 'pages/pages.dart';

class AppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BottomNavigationBloc bottomNavigationBloc =
        BlocProvider.of<BottomNavigationBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Stickmart Ops'),
      ),
      body: BlocBuilder<BottomNavigationEvent, BottomNavigationState>(
        bloc: bottomNavigationBloc,
        builder: (BuildContext context, BottomNavigationState state) {
          if (state is PageLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is MartboxPageLoaded) {
            return MartBoxPage(text: state.text);
          }
          if (state is FirstPageLoaded) {
            return FirstPage(text: state.text);
          }
          if (state is SecondPageLoaded) {
            return SecondPage(number: state.number);
          }
          return Container();
        },
      ),
      bottomNavigationBar:
          BlocBuilder<BottomNavigationEvent, BottomNavigationState>(
              bloc: bottomNavigationBloc,
              builder: (BuildContext context, BottomNavigationState state) {
                return BottomNavigationBar(
                  backgroundColor: Colors.white,
                  selectedItemColor: Colors.purple,
                  unselectedItemColor: Colors.grey,
                  currentIndex: bottomNavigationBloc.currentIndex,
                  type: BottomNavigationBarType.fixed,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.laptop_mac),
                      title: Text('Martbox'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.event),
                      title: Text('Ads'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.history),
                      title: Text('Order History'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.phone_iphone),
                      title: Text('Device'),
                    ),
                  ],
                  onTap: (index) =>
                      bottomNavigationBloc.dispatch(PageTapped(index: index)),
                );
              }),
    );
  }
}
