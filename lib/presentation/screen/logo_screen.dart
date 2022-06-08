import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_control/domain/cubit/common_cubit.dart';
import 'package:money_control/domain/cubit/data_cubit.dart';
import 'package:money_control/helpers/constants/app_screen_routes.dart';

class LogoScreen extends StatefulWidget {
  const LogoScreen({Key? key}) : super(key: key);

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  Future<void> loadScreen(
      context, DataCubit dataCubit, CommonCubit commonCubit) async {
    await dataCubit.loadData();

    await Future.delayed(const Duration(milliseconds: 700));

    commonCubit.initialize(dataCubit);
    Navigator.of(context).pushReplacementNamed(AppScreenRoutes.commonScreen);
  }

  @override
  void initState() {
    final dataCubit = BlocProvider.of<DataCubit>(context);
    final commonCubit = BlocProvider.of<CommonCubit>(context);

    loadScreen(context, dataCubit, commonCubit);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff1d2671),
            Color(0xffaa076b),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
