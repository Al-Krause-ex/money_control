import 'package:money_control/data/models/custom_card.dart';
import 'package:money_control/data/models/category.dart';
import 'package:money_control/data/models/data_storage.dart';
import 'package:money_control/data/models/position_item.dart';
import 'package:money_control/data/models/tabs_screen_arguments.dart';
import 'package:money_control/data/models/transaction.dart';
import 'package:money_control/domain/cubit/data_cubit.dart';
import 'package:money_control/helpers/extensions/custom_date.dart';
import 'package:money_control/presentation/widgets/alert_dialog_filter.dart';
import 'package:money_control/presentation/widgets/carousel_item.dart';
import 'package:money_control/presentation/widgets/main_drawer.dart';
import 'package:money_control/presentation/widgets/new_transaction.dart';
import 'package:money_control/presentation/widgets/transaction_item.dart';
import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'settings_screen.dart';

class CommonScreen extends StatefulWidget {
  @override
  _CommonScreenState createState() => _CommonScreenState();
}

class _CommonScreenState extends State<CommonScreen> {
  double appBarSize = 0.0;
  double systemHeight = 0.0;
  double availableHeight = 0.0;
  double availableWidth = 0.0;

  CarouselController buttonCarouselController = CarouselController();
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  List<String> datesSelection = [
    'Эта неделя',
    'Пред неделя',
    'Месяц',
    'Пред месяц',
  ];

  //var filterTransactionsByCategoryId = ['None'];

  var currentDateSelection = 'Эта неделя';

  var currentSlider = 0;
  var balance = 0;

  var availableToSpendProducts = 2500;
  var availableToSpendAdditionalCosts = 1050;
  var needToPayCredit = 2150;
  var needToPayUtilities = 3000;

  var dateTimeNow = DateTime.now();
  var uuid = Uuid();

  DateTime dateStart = DateTime.now();
  DateTime dateEnd = DateTime.now();

  int today = 0;
  int lastDay = 0;
  int leftDays = 0;

  List<Transaction> visibleTx = [];

  var isLoading = true;

  Future<void> initStateAsync() async {
    await dataStorage.loadData();

    balance = dataStorage.totalBalance;

    Intl.defaultLocale = 'ru_RUS';

    dateStart = dateTimeNow.withoutTime();
    dateEnd = dateTimeNow.withoutTime();

    isLoading = false;

    _initializeDatesSelector(currentDateSelection);

    for (var card in dataStorage.appliedCards) {
      if (DateTime.now()
          .withoutTime()
          .isAfter(card.createdDate.withoutTime())) {
        final diff = DateTime.now()
            .withoutTime()
            .difference(card.createdDate.withoutTime())
            .inDays;

        card.currentDay += diff;
        //card.currentDay++;
        card.createdDate = DateTime.now();

        resetCycleCardData(card);
      }
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    initStateAsync();

    _deleteData(false);
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      backgroundColor: Colors.transparent,
      brightness: Brightness.dark,
      title: Transform(
        transform: Matrix4.translationValues(0.0, 10.0, 0.0),
        child: Text(
          'Money Control',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      centerTitle: true,
      elevation: 0,
    );

    var mediaQuery = MediaQuery.of(context);
    appBarSize = appBar.preferredSize.height;
    systemHeight = mediaQuery.padding.top;
    availableHeight = mediaQuery.size.height - appBarSize - systemHeight;
    availableWidth = mediaQuery.size.width;

    var balanceStr = balance.toString();
    var newBalanceStr = '';
    var count = 0;

    for (int i = 0; i < balanceStr.length; i++) {
      newBalanceStr += balanceStr[i];

      if (i == 0 && balanceStr[0] == '-') newBalanceStr += ' ';

      count++;

      if ((balanceStr.length - count) % 3 == 0) {
        newBalanceStr += ' ';
      }
    }

    if (dateStart != null && dateEnd != null) {
      visibleTx = dataStorage.transactions.where((transaction) {
        var start =
            transaction.date.withoutTime().isAtSameMomentAs(dateStart) ||
                transaction.date.withoutTime().isAfter(dateStart);
        var end = transaction.date.withoutTime().isAtSameMomentAs(dateEnd) ||
            transaction.date.withoutTime().isBefore(dateEnd);

        if (start && end) {
          return true;
        } else {
          return false;
        }
      }).toList();
    }

    //Sort tx by date
    visibleTx.sort((a, b) {
      var aD = a.date;
      var bD = b.date;

      return bD.compareTo(aD);
    });

    if (dataStorage.filterCategoryIds.isNotEmpty) {
      if (dataStorage.filterCategoryIds.first != 'None') {
        var sortedTx = <Transaction>[];

        for (var tx in visibleTx) {
          if (dataStorage.filterCategoryIds.contains(tx.categoryId)) {
            sortedTx.add(tx);
          }
        }

        visibleTx = sortedTx.toList();
      }
    }

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
        // drawer: MainDrawer(dataCubit: ),
        appBar: AppBar(
          brightness: Brightness.dark,
          leading: Transform(
            transform: Matrix4.translationValues(0.0, 7.0, 0.0),
            child: IconButton(
              splashRadius: 20.0,
              icon: Icon(Icons.menu, size: 24.0),
              onPressed: () => _drawerKey.currentState?.openDrawer(),
            ),
          ),
          backgroundColor: Colors.transparent,
          title: Transform(
            transform: Matrix4.translationValues(0.0, 10.0, 0.0),
            child: Text(
              'Money Control',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildCarouselSlider(),
                  buildBalanceInfo(newBalanceStr),
                  buildButtonsDatesAndFilter(),
                  buildExpandedTransactionsList(),
                ],
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: Container(
          width: 60.0,
          height: 60.0,
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              if (dataStorage.appliedCategories.isEmpty) {
                // ignore: deprecated_member_use
                // _drawerKey.currentState?.removeCurrentSnackBar();
                // ignore: deprecated_member_use
                // _drawerKey.currentState?.showSnackBar(
                //   SnackBar(
                //     duration: Duration(seconds: 2),
                //     content: Text('У вас ещё нет категорий'),
                //     action: SnackBarAction(
                //       label: 'Создать категорию',
                //       onPressed: () {
                //         Navigator.pushNamed(
                //           context,
                //           SettingsScreen.routeName,
                //           arguments: TabsScreenArguments(2),
                //         );
                //       },
                //     ),
                //   ),
                // );
              } else {
                // _addNewTransaction(context, );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildExpandedTransactionsList() {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          return Dismissible(
            key: GlobalKey(),
            onDismissed: (direction) {
              setState(() {
                // var deletedTransaction = visibleTx[index];
                //
                // for (var card in dataStorage.appliedCards) {
                //   if (card.categoryId == deletedTransaction.categoryId &&
                //       card.markId == deletedTransaction.markId) {
                //     card.passedSum -= deletedTransaction.sum;
                //   }
                // }

                // if (deletedTransaction.category.action == 0) {
                //   dataStorage.totalBalance += deletedTransaction.sum;
                //   balance += deletedTransaction.sum;
                // } else {
                //   dataStorage.totalBalance -= deletedTransaction.sum;
                //   balance -= deletedTransaction.sum;
                // }

                // dataStorage.transactions.removeWhere(
                //     (transaction) => transaction.id == deletedTransaction.id);
                //
                // dataStorage.saveData();
              });

              // ignore: deprecated_member_use
              // _drawerKey.currentState?.hideCurrentSnackBar();
              // ignore: deprecated_member_use
              // _drawerKey.currentState?.showSnackBar(
              //   SnackBar(
              //     duration: Duration(seconds: 2),
              //     content:
              //         Text('Транзакция "${visibleTx[index].title}" удалена'),
              //   ),
              // );
              // Scaffold.of(context)
              //     .showSnackBar(SnackBar(content: Text("${visibleTx[index]} dismissed")));
            },
            child: Column(
              children: [
                // TransactionItem(
                //   visibleTx[index].title,
                //   visibleTx[index].sum,
                //   visibleTx[index].date,
                //   visibleTx[index].category,
                //   visibleTx[index].positions,
                // ),
                // if (countItems == visibleTx.length)
                //   SizedBox(
                //     height: availableHeight * 0.0533,
                //     //height: 35.0,
                //   ),
              ],
            ),
          );
        },
        itemCount: visibleTx.length,
      ),
    );
  }

  Widget buildButtonsDatesAndFilter() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 7.0, bottom: 4.0),
              child: Stack(
                children: [
                  Center(child: _buildDropdownButtonDates()),
                  Padding(
                    padding: const EdgeInsets.only(right: 33.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          border: dataStorage.filterCategoryIds[0] == 'None'
                              ? Border.all(color: Colors.black, width: 1)
                              : Border.all(color: Colors.green, width: 3),
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.white,
                        ),
                        child: GestureDetector(
                          child: IconTheme(
                            data: IconThemeData(
                              color: Colors.black,
                            ),
                            child: Icon(Icons.filter_list),
                          ),
                          onTap: () {
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return AlertDialogFilter(
                            //         dataStorage.filterCategoryIds);
                            //   },
                            // ).then((value) {
                            //   if (value != null) {
                            //     setState(() {
                            //       dataStorage.filterCategoryIds = value;
                            //       if (dataStorage.filterCategoryIds.length ==
                            //           0) {
                            //         dataStorage.filterCategoryIds = ['None'];
                            //       }
                            //
                            //       dataStorage.saveFilterData();
                            //     });
                            //   }
                            // });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildRaisedButtonDate(true),
                _buildRaisedButtonDate(false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBalanceInfo(String newBalanceStr) {
    var income = 0;
    var costs = 0;

    // visibleTx.forEach((tx) {
    //   if (tx.category.action == 1)
    //     income += tx.sum;
    //   else
    //     costs += tx.sum;
    // });

    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              'Баланс',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white70,
              ),
            ),
          ),
          Text(
            '$newBalanceStrруб',
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          SizedBox(height: 10.0),
          Text(
            '+ $income руб',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              color: Color(0xff57DB8F),
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            '- $costs руб',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              color: Color(0xffFF6D88),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCarouselSlider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      width: double.infinity,
      //height: availableHeight * 0.21,
      height: 150.0,
      child: CarouselSlider(
        carouselController: buttonCarouselController,
        options: CarouselOptions(
            initialPage: currentSlider,
            viewportFraction: 0.5,
            enlargeCenterPage: false,
            onPageChanged: (index, page) {
              setState(() {
                currentSlider = index;
              });
            }),
        items: dataStorage.appliedCards.length > 0
            ? dataStorage.appliedCards.map((card) {
                return CarouselItem(
                  id: card.id,
                  categoryId: card.categoryId,
                  title: card.title,
                  allMoney: card.allSum,
                  passedMoney: card.passedSum,
                  passedDays: card.currentDay,
                  lastDay: card.lastDay,
                  today: today,
                  bgColor: card.bgColorOne,
                  fgColor: card.fgColor,
                  colorId: card.colorId,
                  isEmpty: false,
                  width: availableWidth,
                );
              }).toList()
            : List.generate(1, (index) {
                return CarouselItem(
                  isEmpty: true,
                  width: availableWidth,
                );
              }).toList(),
      ),
    );
  }

  void resetCycleCardData(CustomCard card) {
    var beginningNextMonth = (dateTimeNow.month < 12)
        ? DateTime(dateTimeNow.year, dateTimeNow.month + 1, 1)
        : DateTime(dateTimeNow.year + 1, 1, 1);

    var lastDayInMonth = beginningNextMonth.subtract(Duration(days: 1)).day;

    setState(() {
      if (card.currentDay == card.lastDay && !card.isLastDay) {
        card.isLastDay = true;
        card.lastDayDate = DateTime.now().withoutTime();
      } else if (card.currentDay > card.lastDay) {
        var diffBetweenCurrAndLastDays = card.lastDay - card.currentDay;
        if (diffBetweenCurrAndLastDays < 0) diffBetweenCurrAndLastDays *= -1;

        card.isLastDay = false;
        card.currentDay = diffBetweenCurrAndLastDays;
        card.passedSum = 0;
        card.markId = uuid.v4();
        card.lastDayDate = DateTime(2099, 1, 1);
      } else if (card.isLastDay &&
          card.lastDayDate.isBefore(DateTime.now().withoutTime())) {
        card.isLastDay = false;
        card.currentDay = 1;
        card.passedSum = 0;
        card.markId = uuid.v4();
        card.lastDayDate = DateTime(2099, 1, 1);

        if (card.type == TypeCard.Monthly) card.lastDay = lastDayInMonth;
      }

      dataStorage.saveData();
    });
  }

  // void _addNewTransaction(BuildContext ctx, DataCubit dataCubit) {
  //   showModalBottomSheet(
  //     context: ctx,
  //     builder: (context) {
  //       return GestureDetector(
  //         onTap: () {},
  //         child: NewTransaction(dataCubit: dataCubit),
  //         behavior: HitTestBehavior.opaque,
  //       );
  //     },
  //   ).then((value) {
  //     if (value != null) {
  //       print(value);
  //
  //       _initializeDataFromNewTransaction(
  //         value['id'],
  //         value['category'],
  //         value['money'],
  //         value['date'],
  //         value['positions'],
  //       );
  //     }
  //   });
  // }

  void _initializeDataFromNewTransaction(
    String id,
    Category category,
    int bill,
    DateTime date,
    List<PositionItem> positions,
  ) {
    setState(() {
      String titleTransaction;

      for (var card in dataStorage.appliedCards) {
        if (category.id == card.categoryId) {
          card.passedSum += bill;
        }
      }

      if (category.action == 0) {
        dataStorage.totalBalance -= bill;
        balance -= bill;
      } else {
        dataStorage.totalBalance += bill;
        balance += bill;
      }

      titleTransaction = category.title;

      var markIdToTx = '';

      for (var card in dataStorage.appliedCards) {
        if (category.id == card.categoryId) {
          markIdToTx = card.markId;
        }

        print(card.title);
        print(card.markId);
        print(markIdToTx);
      }

      // dataStorage.transactions.add(Transaction(
      //   positions,
      //   id: id,
      //   title: titleTransaction,
      //   markId: markIdToTx,
      //   sum: bill,
      //   date: date,
      //   category: category,
      // ));

      dataStorage.saveData();
    });
  }

  void _deleteData(isLoad) async {
    final prefs = await SharedPreferences.getInstance();

    if (isLoad) {
      prefs.remove('KeyTransactionsData');
      prefs.remove('KeyMoneyData');
      prefs.remove('KeyCategoriesData');
      prefs.remove('KeyCardsData');
    }
  }

  void _initializeDatesSelector(String nValue) {
    switch (nValue) {
      case 'Эта неделя':
        var today = dateTimeNow.weekday; //DateTime.now().weekday;
        var endNum = 7 - today;

        dateEnd = dateTimeNow.add(Duration(days: endNum)).withoutTime();
        dateStart = dateEnd.subtract(Duration(days: 6)).withoutTime();
        break;
      case 'Пред неделя':
        var today = dateTimeNow.weekday;
        var endNum = 7 - today;

        dateEnd = (dateTimeNow.add(Duration(days: endNum)))
            .subtract(Duration(days: 7))
            .withoutTime();
        dateStart = dateEnd.subtract(Duration(days: 6)).withoutTime();
        break;
      case 'Месяц':
        var currentMonth = dateTimeNow.month;

        dateStart = DateTime(dateTimeNow.year, currentMonth, 1).withoutTime();
        dateEnd = DateTime(dateTimeNow.year, currentMonth + 1, 0).withoutTime();
        break;
      case 'Пред месяц':
        var month = dateTimeNow.month;
        var year = dateTimeNow.year;

        if (month - 1 == 0) {
          month = 12;
          year -= 1;
        } else {
          month -= 1;
        }

        dateStart = DateTime(year, month, 1).withoutTime();
        dateEnd = DateTime(year, month + 1, 0).withoutTime();
        break;
    }
  }

  Widget _buildDropdownButtonDates() {
    return DropdownButton(
      icon: Icon(
        Icons.arrow_drop_down,
        color: Colors.white,
      ),
      dropdownColor: Color(0xff1d2671).withOpacity(0.7),
      value: currentDateSelection,
      items: datesSelection.map((date) {
        return DropdownMenuItem(
          value: date,
          child: Row(
            children: [
              Text(
                date,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (nValue) {
        setState(() {
          currentDateSelection =
              datesSelection.firstWhere((date) => date == nValue);
          _initializeDatesSelector(nValue as String);
        });
      },
    );
  }

  Widget _buildRaisedButtonDate(bool isDateStart) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            isDateStart ? 'От' : 'До',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              primary: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 14.0, bottom: 14.0),
              child: Text(
                DateFormat.yMd().format(isDateStart ? dateStart : dateEnd),
                style: TextStyle(color: Colors.black),
              ),
            ),
            onPressed: () {
              showDatePicker(
                locale: const Locale('ru', 'RU'),
                context: context,
                initialDate: isDateStart ? dateStart : dateEnd,
                firstDate: DateTime(2020),
                lastDate: DateTime(2099),
              ).then((dateValue) {
                if (dateValue != null) {
                  setState(() {
                    if (isDateStart) {
                      dateStart = DateTime(
                        dateValue.year,
                        dateValue.month,
                        dateValue.day,
                      );
                    } else {
                      dateEnd = DateTime(
                        dateValue.year,
                        dateValue.month,
                        dateValue.day,
                      );
                    }
                  });
                }
              });
            },
          ),
        ),
      ],
    );
  }
}
