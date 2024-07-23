import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class Bar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPct;
  Bar(this.label, this.spendingAmount, this.spendingPct);
  @override
  Widget build(BuildContext context) {
    print('build() Bar');
    return LayoutBuilder(builder: ((context, constraints) {
      return Column(
        children: [
          Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                  child: Text('₹ ${spendingAmount.toStringAsFixed(0)}'))),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            height: constraints.maxHeight * 0.6,
            width: 10,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromRGBO(220, 220, 220, 1)),
                ),
                FractionallySizedBox(
                  heightFactor: spendingPct,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            child: FittedBox(child: Text('${label}')),
            height: constraints.maxHeight * 0.15,
          ),
        ],
      );
    }));
  }
}
