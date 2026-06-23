
import 'package:flutter/material.dart';
import 'package:life_help_calandar_project/data/user_database.dart';


// Custom Widgets

// Data

// Finance

// Goal
import 'package:life_help_calandar_project/finance/finance_page.dart';
import 'package:life_help_calandar_project/finance/finance_payment.dart';

// Health - Exercise

// Health - Nutrition

// Health - General

// Home

// Main Layout & Entry Point


class Finance_Data_Content extends StatefulWidget {
  const Finance_Data_Content({super.key});

  @override
  _Finance_Data_Content createState() => _Finance_Data_Content();
}

class _Finance_Data_Content extends State<Finance_Data_Content> {
  Widget? selectedFinancePage;
  late Future<List <Map<String, dynamic>>> _finances;
  @override
  void initState() {
    super.initState();
    _finances = fetchfinances();
  }
  @override
  Future<List<Map<String, dynamic>>> fetchfinances()async{
    final db = await DatabaseHelper().database;
    return await db.query(
      'finances',
      orderBy: 'datetime DESC',
    );
  }
  @override
  Widget build(BuildContext context) {
    return Center(
        child: selectedFinancePage ?? Column(
          children: [
            FutureBuilder(
                future: _finances,
                builder: (contect, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting){
                    return const Center(
                        child: CircularProgressIndicator()
                    );
                  }
                  else if(snapshot.hasError){
                    return Center(
                        child: Text('Error')
                    );
                  } else if(!snapshot.hasData || snapshot.data!.isEmpty){
                    return const Center(child: Text('No Goals have been made.'));}
                  final finances = snapshot.data!;
                  return
                    Expanded(child:
                    ListView.builder(
                        itemCount: finances.length,
                        itemBuilder: (context, i){
                          final finance = finances[i];
                          return Card(
                            child: ListTile(
                                title: Text(finance['finance_note'] ?? 'N/A'),
                                onTap: (){
                                  setState(() {
                                    selectedFinancePage = FinancePaymentContent(
                                        id: finance['id'],
                                        finance_category: finance['finance_category'],
                                        datetime: finance['datetime'],
                                        finance_amount: finance['finance_amount'],
                                        finance_note: finance['finance_note']);
                                    });}
                            ),
                          );
                        }
                    ));
                }
            ),
            ElevatedButton(
                onPressed:(){
                  setState((){
                    selectedFinancePage = FinancePageContent();
                  });
                },
                child: Text('Back')),
          ],
        )
    );
  }
}