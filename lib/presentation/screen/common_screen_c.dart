import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:money_control/domain/cubit/common_cubit.dart';
import 'package:money_control/domain/cubit/data_cubit.dart';
import 'package:money_control/domain/cubit/settings_cubit.dart';
import 'package:money_control/helpers/constants/app_screen_routes.dart';
import 'package:money_control/helpers/show_helper.dart';
import 'package:money_control/presentation/widgets/common/balance_info.dart';
import 'package:money_control/presentation/widgets/common/button_dates_filter.dart';
import 'package:money_control/presentation/widgets/common/list_transactions.dart';
import 'package:money_control/presentation/widgets/main_drawer.dart';
import 'package:money_control/presentation/widgets/new_transaction.dart';

class CommonScreenC extends StatelessWidget {
  CommonScreenC({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final dataCubit = BlocProvider.of<DataCubit>(context);
    final commonCubit = BlocProvider.of<CommonCubit>(context);

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
        key: _drawerKey,
        endDrawerEnableOpenDragGesture: false,
        drawer: MainDrawer(dataCubit: dataCubit),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Transform(
            transform: Matrix4.translationValues(0.0, 7.0, 0.0),
            child: IconButton(
              splashRadius: 20.0,
              icon: Icon(Icons.menu, size: 24.0),
              onPressed: () => _drawerKey.currentState?.openDrawer(),
            ),
          ),
          title: Transform(
            transform: Matrix4.translationValues(0.0, 10.0, 0.0),
            child: Text(
              'Money Control',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        backgroundColor: Colors.transparent,
        body: BlocBuilder<CommonCubit, CommonState>(
          builder: (context, state) {
            print('build: $state');

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // CustomCarouselSlider(
                //   carouselController: carouselController,
                //   currentSlider: 0,
                //   today: 0,
                // ),
                const SizedBox(height: 20.0),
                BalanceInfo(
                  dataCubit: dataCubit,
                  visibleTransactions: state.transactions,
                  balance: dataCubit.state.customUser.totalBalance,
                ),
                ButtonDatesFilter(
                  dataCubit: dataCubit,
                  commonCubit: commonCubit,
                ),
                //context.read<CommonCubit>() - если хотим юзать кубит из context
                ListTransactions(
                  dataCubit: dataCubit,
                  commonCubit: commonCubit,
                  visibleTransactions: state.transactions,
                ),
              ],
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: Container(
          width: 60.0,
          height: 60.0,
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              if (dataCubit.state.customUser.categories.isEmpty) {
                ShowHelper.showMessage(
                  context,
                  title: 'У вас ещё нет категорий',
                  duration: Duration(seconds: 2),
                  snackBarAction: SnackBarAction(
                    label: 'Создать категорию',
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppScreenRoutes.settingsScreen,
                        arguments: {
                          'cats': dataCubit.state.customUser.categories.length,
                          'indexPage': IndexPage.categories
                        },
                      );
                    },
                  ),
                );
              } else {
                _addNewTransaction(
                  context,
                  dataCubit,
                  commonCubit,
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void _addNewTransaction(
    BuildContext ctx,
    DataCubit dataCubit,
    CommonCubit commonCubit,
  ) {
    showModalBottomSheet(
      context: ctx,
      builder: (context) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(dataCubit: dataCubit, commonCubit: commonCubit),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }
}
