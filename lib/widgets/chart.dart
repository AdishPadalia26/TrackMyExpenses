import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import 'transactionlist.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  Chart(this.recentTransactions){
    print('Chart Constructor');
  }
  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalAmount = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalAmount += recentTransactions[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalAmount
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactions.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactions);

    return Card(
      elevation: 6,
      margin: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactions.map((data) {
              return Flexible(
                fit: FlexFit.tight,
                child: Bar(
                  data['day'] as String,
                  data['amount'] as double,
                  totalSpending == 0
                      ? 0.0
                      : (data['amount'] as double) / totalSpending,
                ),
              );
            }).toList()),
      ),
    );
  }
}
