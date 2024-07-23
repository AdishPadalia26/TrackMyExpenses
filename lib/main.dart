import 'dart:io';
import 'package:expenseplanner/widgets/chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import './widgets/chart.dart';
import './widgets/newTransactions.dart';
import 'package:flutter/material.dart';
import './widgets/transactionlist.dart';
import './models/transaction.dart';
import 'package:flutter/material.dart';

void main() {
  //For Prohibiting landscape mode
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
          primarySwatch: Colors.teal,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.teal,
          ).copyWith(
            secondary: Colors.amber, // Your accent color
          ),
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
          appBarTheme: AppBarTheme(
              titleTextStyle: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ))),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  // String titleInput = '';

  final List<Transaction> _userTransactions = [];
  bool _showChart = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    print(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _addNewTransaction(
      String newTitle, double newAmount, DateTime chosenDate) {
    final newtx = Transaction(
        id: DateTime.now().toString(),
        title: newTitle,
        amount: newAmount,
        date: chosenDate);
    setState(() {
      _userTransactions.add(newtx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: NewTransaction(_addNewTransaction),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        Duration(
          days: 7,
        ),
      ));
    }).toList();
  }

  List<Widget> _buildLandscape(
      MediaQueryData mediaQuery, AppBar appBar, txList) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Show chart',
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          Switch.adaptive(
              activeColor: Theme.of(context).colorScheme.secondary,
              value: _showChart,
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              })
        ],
      ),
      _showChart
          ? Container(
              child: Chart(_recentTransactions),
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.6)
          : txList
    ];
  }

  List<Widget> _buildPortrait(
      MediaQueryData mediaQuery, AppBar appBar, txList) {
    return [
      Container(
          child: Chart(_recentTransactions),
          height: (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              0.3),
      txList
    ];
  }

  Widget _buildIOSNavigationBar(pageBody) {
    return CupertinoPageScaffold(
      child: pageBody,
      navigationBar: CupertinoNavigationBar(
          middle: Text('Expense Controller'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => _startAddNewTransaction(context),
                child: Icon(CupertinoIcons.add),
              )
            ],
          )),
    );
  }

  Widget _buildAndroidNavigationBar(AppBar appBar, pageBody) {
    return Scaffold(
      appBar: appBar,
      body: pageBody,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              onPressed: () => _startAddNewTransaction(context),
              child: Icon(Icons.add),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('build() MyHomePage');
    final mediaQuery = MediaQuery.of(context);

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text("Expense Controller"),
      actions: <Widget>[
        IconButton(
            onPressed: () => _startAddNewTransaction(context),
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ))
      ],
    );

    final txList = Container(
      child: TransactionList(_userTransactions, _deleteTransaction),
      height: isLandscape
          ? (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  MediaQuery.of(context).padding.top) *
              0.7
          : (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  MediaQuery.of(context).padding.top) *
              0.5,
    );

    final pageBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape) ..._buildLandscape(mediaQuery, appBar, txList),
            if (!isLandscape) ..._buildPortrait(mediaQuery, appBar, txList),
          ]),
    ));
    return Platform.isIOS
        ? _buildIOSNavigationBar(pageBody)
        : _buildAndroidNavigationBar(appBar, pageBody);
  }
}
