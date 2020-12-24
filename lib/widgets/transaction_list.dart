import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transaction;
  final Function deleteTx;
  TransactionList(this.transaction,this.deleteTx);
  
  @override
  Widget build(BuildContext context) {
    return Container(
          height:400,
          child: transaction.isEmpty ? 
          LayoutBuilder(builder: (ctx,constraints){
            return Column(
            children:<Widget>[
              Text(
                'No Transactions added yet!',
                style: Theme.of(context).textTheme.title,
              ),
              SizedBox(
                height:20,
              ),
              Container(
                height: constraints.maxHeight*0.6,
                child: Image.asset('assets/images/waiting.png', fit: BoxFit.cover,),
                ),
            ],
          );
          })
          :
           ListView.builder(
            itemBuilder: (ctx,index){
            return Card(
              margin: EdgeInsets.symmetric(vertical:8,horizontal:5),
              elevation:5,
               child: ListTile(
                leading: CircleAvatar(
                  radius:30,
                  child: Padding(
                    padding: EdgeInsets.all(6),
                    child: FittedBox(
                      child:Text('\$${transaction[index].amount}',),
                    ),
                  ),
                  ),
                  title: Text(
                    transaction[index].title,
                    style: Theme.of(context).textTheme.title,
                    ),
                  subtitle: Text(
                    DateFormat.yMMMd().format(transaction[index].date),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete), 
                    color: Theme.of(context).errorColor,
                    onPressed: () => deleteTx(transaction[index].id)
                    ),
                  ),
            );
                
              },
              itemCount: transaction.length,
              ),
          );
  }
}