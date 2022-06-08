import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:money_control/helpers/constants/app_screen_routes.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {

  SettingsCubit({
    required int cats,
    required IndexPage indexPage,
  }) : super(SettingsInitial(cats: cats, indexPage: indexPage));

  void changePage(context, int index) {
    if (index == 1) {
      // Navigator.of(context).pop();
      Navigator.of(context).pushNamedAndRemoveUntil(
          AppScreenRoutes.commonScreen, (Route<dynamic> route) => false);
      return;
    }

    emit(SettingsChangedPage(
        cats: state.cats, indexPage: IndexPage.values[index]));
  }
}
