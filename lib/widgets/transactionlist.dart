import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function _deleteTransaction;
  TransactionList(this.transactions, this._deleteTransaction);

  @override
  Widget build(BuildContext context) {
    print('build() TransactionList');
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: ((context, constraints) {
              return Column(
                children: [
                  Text(
                    "No transaction yet!",
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: constraints.maxHeight * 0.1,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600),
                  ),
                  Container(
                    height: constraints.maxHeight * 0.8,
                    child: Image.asset(
                      'assets/images/expenses.jpg',
                    ),
                  ),
                ],
              );
            }),
          )
        : TransactionItem(
            transactions: transactions, deleteTransaction: _deleteTransaction);
  }
}
