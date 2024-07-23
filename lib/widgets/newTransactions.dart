import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function _addtx;
  NewTransaction(this._addtx) {
    print('new State Constructor');
  }

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime _selectedDate = DateTime(2018);

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  void initState() {
    print("intitState()");
    super.initState();
  }

  @override
  void didUpdateWidget(NewTransaction oldWidget) {
    print('didUpdateWidget()');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    print('dispose()');
    super.dispose();
  }

  void _submitData() {
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);
    if (enteredAmount <= 0 ||
        enteredTitle.isEmpty ||
        _selectedDate == DateTime(2018)) {
      return;
    }
    widget._addtx(enteredTitle, enteredAmount, _selectedDate);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 12,
              left: 12,
              right: 12,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Title"),
                controller: titleController,
                onSubmitted: (_) => _submitData,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Amount"),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Text(
                      _selectedDate == DateTime(2018)
                          ? 'No Date Chosen!'
                          : 'Picked Date:${DateFormat.yMd().format(_selectedDate)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Expanded(
                      child: Platform.isIOS
                          ? CupertinoButton(
                              child: Text(
                                'Choose Date',
                                style: TextStyle(
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),
                              onPressed: _presentDatePicker)
                          : TextButton(
                              onPressed: _presentDatePicker,
                              child: Text(
                                'Choose Date',
                                style: TextStyle(
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),
                            ),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _submitData,
                child: Text(
                  "Add Transaction",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
