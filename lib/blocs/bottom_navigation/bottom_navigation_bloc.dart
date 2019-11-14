import 'dart:async';

import 'package:bloc/bloc.dart';
import 'bottom_navigation_event.dart';
import 'bottom_navigation_state.dart';
import 'package:bottom_navigation_bloc/repositories/first_page_repository.dart';
import 'package:bottom_navigation_bloc/repositories/second_page_respository.dart';
import 'package:bottom_navigation_bloc/repositories/martbox_repository.dart';

class BottomNavigationBloc
    extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  final FirstPageRepository firstPageRepository;
  final SecondPageRepository secondPageRepository;
  final MartboxPageRepository martboxPageRepository;
  int currentIndex = 0;

  BottomNavigationBloc({this.martboxPageRepository, this.firstPageRepository, this.secondPageRepository})
      : assert(firstPageRepository != null),
        assert(secondPageRepository != null),
        assert(martboxPageRepository != null);

  @override
  BottomNavigationState get initialState => PageLoading();

  @override
  Stream<BottomNavigationState> mapEventToState(
      BottomNavigationEvent event) async* {
    if (event is AppStarted) {
      this.dispatch(PageTapped(index: this.currentIndex));
    }
    if (event is PageTapped) {
      this.currentIndex = event.index;
      yield CurrentIndexChanged(currentIndex: this.currentIndex);
      yield PageLoading();

      if (this.currentIndex == 0) {
        String data = await _getMartboxPageData();
        yield MartboxPageLoaded(text: data);
      }
      if (this.currentIndex == 1) {
        String data = await _getFirstPageData();
        yield FirstPageLoaded(text: data);
      }
      if (this.currentIndex == 2) {
        int data = await _getSecondPageData();
        yield SecondPageLoaded(number: data);
      }
    }
  }

  Future<String> _getMartboxPageData() async {
    String data = martboxPageRepository.data;
    if (data == null) {
      await martboxPageRepository.fetchData();
      data = martboxPageRepository.data;
    }
    return data;
  }

  Future<String> _getFirstPageData() async {
    String data = firstPageRepository.data;
    if (data == null) {
      await firstPageRepository.fetchData();
      data = firstPageRepository.data;
    }
    return data;
  }

  Future<int> _getSecondPageData() async {
    int data = secondPageRepository.data;
    if (data == null) {
      await secondPageRepository.fetchData();
      data = secondPageRepository.data;
    }
    return data;
  }
}
