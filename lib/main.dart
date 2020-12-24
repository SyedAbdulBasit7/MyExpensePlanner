import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import './models/transaction.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
void main(){
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   [
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ]
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
      title: "Personal Expenses",
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Quicksand',

        textTheme: ThemeData.light().textTheme.copyWith(
          title:TextStyle(
            fontFamily:'OpenSans',
            fontSize:18,
            fontWeight: FontWeight.bold,
          ),
          button:TextStyle(
            color:Colors.white
          ),
        ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget{
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 final List<Transaction> userTransaction=[
    // Transaction(id:"t1", title: "New Shoes",amount: 45.34, date: DateTime.now()),
    // Transaction(id:"t2", title: "Yahoo", amount: 45.98, date: DateTime.now()),
  ];

  bool showChart = false;

  List<Transaction> get recentTransaction{
    return userTransaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days:7),
          ),
        );
    }).toList();
  }



  void addNewTransaction(String txTitle, double txAmount, DateTime  choosenDate){
    final newTx= Transaction(
      title: txTitle, 
      amount: txAmount, 
      date: choosenDate, 
      id: DateTime.now().toString());

      setState(() {
        userTransaction.add(newTx);
      });

  }

  void startAddNewTransaction(BuildContext ctx){
    showModalBottomSheet(context: ctx, builder: (_){
      return GestureDetector(
        child:NewTransaction(addNewTransaction),
        onTap: (){},
        behavior: HitTestBehavior.opaque,
        );
    },);
  }

  void deleteTransaction(String id){
    setState(() {
      userTransaction.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  Widget build(BuildContext context){
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final appbar= AppBar(
        title: Text("Personal Expenses"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add),
          onPressed: () => startAddNewTransaction(context),
          ),
        ],
      );
    return Scaffold(
      appBar:appbar,
      body: SingleChildScrollView(
              child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            if (isLandscape) Row(children: <Widget>[
              Text('Show Chart'),
              Switch(
                value: showChart,
                onChanged: (val){
                  setState(() {
                    showChart=val;
                  });
                },
              )
            ],),

            showChart ? Container(
              height:(
                MediaQuery.of(context).size.height - 
                appbar.preferredSize.height - 
                MediaQuery.of(context).padding.top) * 0.7,
              child: Chart(recentTransaction),
              )
              : Container(
                child: TransactionList(userTransaction, deleteTransaction),
                height: (
                  MediaQuery.of(context).size.height - 
                  appbar.preferredSize.height - 
                  MediaQuery.of(context).padding.top) * 0.7,
                ),
          ], 
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => startAddNewTransaction(context),
      ),
    );
  }
}