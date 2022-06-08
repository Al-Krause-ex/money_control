import 'package:money_control/data/models/position_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:uuid/uuid.dart';

class AddPositionsScreen extends StatefulWidget {
  static const routeName = '/add-positions-screen';

  final List<PositionItem> positionsReceived;

  AddPositionsScreen(this.positionsReceived);

  @override
  _AddPositionsScreenState createState() => _AddPositionsScreenState();
}

class _AddPositionsScreenState extends State<AddPositionsScreen> {
  final _titleFocusNodes = <FocusNode>[];
  final _priceFocusNodes = <FocusNode>[];
  final _amountFocusNodes = <FocusNode>[];

  var countPositions = 0;

  var tecTitles = <TextEditingController>[];
  var tecPrice = <TextEditingController>[];
  var tecAmount = <TextEditingController>[];

  var validatesPrice = <bool>[];
  var finalValid = true;

  var listIsEdit = <bool>[];
  var positions = <PositionItem>[];

  var uuid = Uuid();

  @override
  void initState() {
    super.initState();

    for (var positionReceived in widget.positionsReceived) {
      countPositions++;
      tecTitles.add(TextEditingController(text: positionReceived.title));
      tecPrice
          .add(TextEditingController(text: positionReceived.price.toString()));
      tecAmount
          .add(TextEditingController(text: positionReceived.amount.toString()));

      listIsEdit.add(false);
      validatesPrice.add(true);

      _titleFocusNodes.add(FocusNode());
      _priceFocusNodes.add(FocusNode());
      _amountFocusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    if (_priceFocusNodes.length != 0) {
      for (var i = 0; i < _priceFocusNodes.length; i++) {
        _titleFocusNodes[i].dispose();
        _priceFocusNodes[i].dispose();
        _amountFocusNodes[i].dispose();
      }
    }
    super.dispose();
  }

  void finishEditingPosition(int index) {
    setState(() {
      if (int.tryParse(tecPrice[index].text) == null)
        validatesPrice[index] = false;
      else
        validatesPrice[index] = true;

      if (int.tryParse(tecAmount[index].text) == null)
        tecAmount[index].text = '1';

      if (tecPrice[index].text != '') {
        listIsEdit[index] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    finalValid = true;
    listIsEdit.forEach((element) {
      if (element) {
        finalValid = false;
        return;
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Добавление позиций',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20.0,
          ),
          Expanded(
            flex: 6,
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return Dismissible(
                  key: GlobalKey(),
                  onDismissed: (direction) {
                    setState(() {
                      countPositions--;

                      tecTitles.removeAt(index);
                      tecPrice.removeAt(index);
                      tecAmount.removeAt(index);

                      listIsEdit.removeAt(index);
                      validatesPrice.removeAt(index);

                      _titleFocusNodes.removeAt(index);
                      _priceFocusNodes.removeAt(index);
                      _amountFocusNodes.removeAt(index);
                    });
                  },
                  child: buildStackCard(index),
                );
              },
              itemCount: countPositions,
            ),
          ),
          //Spacer(),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        countPositions++;
                        tecTitles.add(TextEditingController());
                        tecPrice.add(TextEditingController());
                        tecAmount.add(TextEditingController());

                        listIsEdit.add(true);
                        validatesPrice.add(true);

                        _titleFocusNodes.add(FocusNode());
                        _priceFocusNodes.add(FocusNode());
                        _amountFocusNodes.add(FocusNode());

                        _titleFocusNodes.last.requestFocus();
                      });
                    },
                  ),
                  FloatingActionButton(
                    child: Icon(Icons.done),
                    backgroundColor: finalValid ? Colors.orange : Colors.grey,
                    onPressed: finalValid
                        ? () {
                            for (int i = 0; i < countPositions; i++) {
                              try {
                                positions.add(PositionItem(
                                  id: uuid.v4(),
                                  title: tecTitles[i].text,
                                  price: int.parse(tecPrice[i].text),
                                  amount: int.parse(tecAmount[i].text),
                                ));
                              } catch (error) {
                                print(error);
                              }
                            }

                            Navigator.of(context).pop(positions);
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStackCard(int index) {
    if (listIsEdit[index])
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              bottom: 45.0,
            ),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.only(
                  //bottom: 40.0,
                  left: 10.0,
                  right: 10.0,
                ),
                child: Column(
                  children: [
                    TextField(
                        controller: tecTitles[index],
                        focusNode: _titleFocusNodes[index],
                        onSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_priceFocusNodes[index]);
                        },
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'Название',
                          counterText: "",
                        ),
                        onChanged: (str) {}),
                    TextField(
                        maxLength: 7,
                        controller: tecPrice[index],
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNodes[index],
                        onSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_amountFocusNodes[index]);
                        },
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          hintText: 'Цена за единицу',
                          counterText: "",
                          errorText: validatesPrice[index]
                              ? null
                              : 'Нужно ввести число',
                        ),
                        onChanged: (str) {}),
                    TextField(
                      maxLength: 4,
                      controller: tecAmount[index],
                      keyboardType: TextInputType.number,
                      focusNode: _amountFocusNodes[index],
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        finishEditingPosition(index);
                      },
                      textInputAction: TextInputAction.done,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        hintText: 'Количество',
                        counterText: "",
                        //labelText: 'Количество',
                      ),
                      onChanged: (str) {},
                    ),
                    SizedBox(
                      height: 35.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 15,
            child: FloatingActionButton(
              child: Icon(Icons.done),
              onPressed: () {
                finishEditingPosition(index);
              },
            ),
          ),
        ],
      );
    else {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              bottom: 50.0,
            ),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  bottom: 20.0,
                  left: 10.0,
                  right: 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(tecTitles[index].text),
                    Text(tecPrice[index].text),
                    Text('x${tecAmount[index].text}'),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 13,
            child: FloatingActionButton(
              child: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  listIsEdit[index] = true;
                });
              },
            ),
          ),
        ],
      );
    }
  }
}
