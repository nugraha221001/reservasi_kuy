import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../data/bloc/authentication/authentication_bloc.dart';
import '../../utils/constant/constant.dart';
import '../../utils/routes/route_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;
  late AuthenticationBloc _loginBloc;

  _splashScreen() {
    _timer = Timer(
      const Duration(seconds: 2, milliseconds: 5),
      () {
        _checkIsLogin();
      },
    );
  }

  _checkIsLogin() {
    _loginBloc = context.read<AuthenticationBloc>();
    _loginBloc.add(InitialLogin());
  }

  @override
  void initState() {
    _splashScreen();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
       if(state is IsSuperAdmin){
         context.goNamed(Routes().homeSuperAdmin);
       }else if (state is IsAdmin) {
          context.goNamed(Routes().homeAdmin);
        } else if (state is IsUser) {
          context.goNamed(Routes().home);
        } else if (state is UnAuthenticated) {
          context.goNamed(Routes().login);
        } else {
          context.goNamed(Routes().login);
        }
      },
      child: Scaffold(
        body: Center(
          child: Image.asset(imageSplash),
        ),
      ),
    );
  }
}
