import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../blocs/connectivity/connectivity_bloc.dart';
import '../../blocs/connectivity/connectivity_state.dart';

class InternetScreen extends StatefulWidget {
  const InternetScreen({super.key, required this.onInternetComeBack});
  final VoidCallback onInternetComeBack;

  @override
  State<InternetScreen> createState() => _InternetScreenState();
}

class _InternetScreenState extends State<InternetScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        debugPrint("ON POP INVOKED:$value");
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: BlocListener<ConnectBloc, ConnectState>(
            listener: (context, state) {
              widget.onInternetComeBack();
              if (state.hasInternet ||
                  state.connectResult != ConnectivityResult.none) {
                Navigator.pop(context);
              }
            },
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "NO INTERNET",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
