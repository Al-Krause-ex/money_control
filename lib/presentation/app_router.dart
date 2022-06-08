import 'package:money_control/domain/cubit/data_cubit.dart';
import 'package:money_control/domain/cubit/settings_cubit.dart';
import 'package:money_control/helpers/constants/app_screen_routes.dart';
import 'package:money_control/domain/cubit/common_cubit.dart';
import 'package:money_control/presentation/screen/common_screen.dart';
import 'package:money_control/presentation/screen/common_screen_c.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_control/presentation/screen/generate_report_screen.dart';
import 'package:money_control/presentation/screen/logo_screen.dart';
import 'package:money_control/presentation/screen/settings_screen.dart';
import 'package:money_control/presentation/screen/settings_screen_c.dart';
import 'package:money_control/presentation/screen/statistics_screen.dart';

class AppRouter {
  final DataCubit dataCubit;
  late CommonCubit commonCubit;

  AppRouter({required this.dataCubit});

  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        commonCubit = CommonCubit();

        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: dataCubit),
              BlocProvider.value(value: commonCubit),
            ],
            child: LogoScreen(),
          ),
        );
      case AppScreenRoutes.commonScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: dataCubit),
              BlocProvider.value(value: commonCubit),
            ],
            child: CommonScreenC(),
          ),
        );
      case AppScreenRoutes.settingsScreen:
        final argMap = settings.arguments as Map<String, dynamic>;
        final SettingsCubit settingsCubit = SettingsCubit(
          cats: argMap['cats'],
          indexPage: argMap['indexPage'],
        );

        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: dataCubit),
              BlocProvider.value(value: settingsCubit),
            ],
            child: SettingsScreenC(),
          ),
        );
      case AppScreenRoutes.generateReportScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: dataCubit,
            child: GenerateReportScreen(),
          ),
        );
      case AppScreenRoutes.statisticsScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: dataCubit,
            child: StatisticsScreen(),
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => SizedBox());
    }
  }
}
