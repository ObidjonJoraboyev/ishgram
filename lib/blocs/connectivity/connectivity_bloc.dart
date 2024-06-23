import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'connectivity_event.dart';
import 'connectivity_state.dart';

class ConnectBloc extends Bloc<ConnectEvent, ConnectState> {
  ConnectBloc()
      : super(
          const ConnectState(
            connectResult: ConnectivityResult.none,
            hasInternet: true,
          ),
        ) {
    on<CheckConnect>(_checkConnect);
  }

  Connectivity get _connectivity => Connectivity();

  _checkConnect(CheckConnect event, Emitter emit) async {
    List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    if (results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi)) {
      emit(state.copyWith(hasInternet: true));
    } else {
      emit(state.copyWith(hasInternet: false));
    }
    await emit.onEach(
      _connectivity.onConnectivityChanged,
      onData: (List<ConnectivityResult> results) {
        if (!results.contains(ConnectivityResult.none)) {
          emit(state.copyWith(hasInternet: true));
        } else {
          if (!results.contains(ConnectivityResult.mobile) ||
              !results.contains(ConnectivityResult.wifi)) {
            emit(state.copyWith(hasInternet: false));
          }
        }
      },
    );
  }
}
