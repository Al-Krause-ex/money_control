import 'package:money_control/data/repositories/repository.dart';
import 'package:money_control/domain/cubit/data_cubit.dart';
import 'package:money_control/presentation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'helpers/color_helper.dart';

void main() {
  runApp(
    MoneyControlApp(
      appRouter: AppRouter(
        dataCubit: DataCubit(
          repository: Repository(),
        ),
      ),
    ),
  );
}

class MoneyControlApp extends StatelessWidget {
  final AppRouter appRouter;

  const MoneyControlApp({Key? key, required this.appRouter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      primaryColor: Colors.red,
      primarySwatch: ColorHelper.getMaterialColor(Color(0xFF6A166E)),
      accentColor: Color(0xffFF934B),
      textTheme: ThemeData.light().textTheme.copyWith(
            bodyText1: TextStyle(
              color: Colors.green,
            ),
            bodyText2: TextStyle(
              color: Colors.black,
            ),
            headline6: TextStyle(
              fontFamily: 'Comfortaa',
              fontSize: 20.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
    );

    return MaterialApp(
      title: 'Money Control',
      debugShowCheckedModeBanner: false,
      theme: theme,
      // theme: theme.copyWith(
      //   colorScheme: theme.colorScheme.copyWith(secondary: Color(0xffFF934B)),
      // ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.light,
      onGenerateRoute: appRouter.generateRoute,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
      ],
    );
  }
}
