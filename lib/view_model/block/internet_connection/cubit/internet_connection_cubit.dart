import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'internet_connection_state.dart';

class InternetConnectionCubit extends Cubit<InternetConnectionState> {
  InternetConnectionCubit() : super(InternetConnectionInitial());

  static InternetConnectionCubit get(context) => BlocProvider.of(context);
  StreamSubscription? _subscription;
  bool isConnected = true;

  // Future<void> connected() async {
  //   await CheckServerConnection.checkServerConnection();
  //
  //   isConnected = true;
  //   emit(ConnectedState());
  // }
  //
  // void notConnected() {
  //   isConnected = false;
  //   emit(NotConnectedState(message: "No Internet Connection"));
  // }

  void checkConnection() {
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      if (result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile)) {

      } else {

      }
    });
  }


  @override
  Future<void> close() async {
    _subscription!.cancel();
    super.close();
  }
}
