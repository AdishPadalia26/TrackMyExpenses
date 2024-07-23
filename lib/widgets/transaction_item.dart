import 'dart:math';

import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key? key,
    required this.transactions,
    required Function deleteTransaction,
  })  : _deleteTransaction = deleteTransaction,
        super(key: key);

  final List<Transaction> transactions;
  final Function _deleteTransaction;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  late Color _bgColor;
  List bgColors = [Colors.blue, Colors.purple, Colors.red, Colors.yellow];

  @override
  void initState() {
    setState(() {
      _bgColor = bgColors[Random().nextInt(4)];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 85, top: 10, left: 7, right: 7),
      elevation: 5,
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          return ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(
                  child: Text(
                    '₹${widget.transactions[index].amount}',
                    style: TextStyle(fontFamily: 'OpenSans'),
                  ),
                ),
              ),
              radius: 30,
            ),
            title: Text(
              '${widget.transactions[index].title[0].toUpperCase()}${widget.transactions[index].title.substring(1)}',
              style: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
            subtitle: Text(
                DateFormat.yMMMd().format(widget.transactions[index].date)),
            trailing: MediaQuery.of(context).size.width > 360
                ? TextButton.icon(
                    onPressed: () => widget
                        ._deleteTransaction(widget.transactions[index].id),
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).errorColor,
                    ),
                    label: Text(
                      'Delete',
                      style: TextStyle(color: Theme.of(context).errorColor),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.delete),
                    color: Theme.of(context).errorColor,
                    onPressed: () => widget
                        ._deleteTransaction(widget.transactions[index].id),
                  ),
          );
        },
        itemCount: widget.transactions.length,
      ),
    );
  }
}
