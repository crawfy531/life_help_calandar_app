import 'package:flutter/material.dart';
import 'package:life_help_calandar_project/data/user_database.dart';
import 'package:life_help_calandar_project/finance/finance_payment.dart';
import 'package:life_help_calandar_project/finance/finance_graphs.dart';
import 'package:life_help_calandar_project/goal/new_goal.dart';
import 'package:life_help_calandar_project/finance/finance_pie_chart.dart';
import 'package:life_help_calandar_project/finance/view_finance_data.dart';


class FinancePageContent extends StatefulWidget {
  const FinancePageContent({super.key});

  @override
  _FinancePageContentState createState() => _FinancePageContentState();
}

class _FinancePageContentState extends State<FinancePageContent> {
  Widget? selectedFinancePage;
  Map<String, int>? financeData;
  late Future<List <Map<String, dynamic>>> _finance_Goals;


  @override
  void initState() {
    super.initState();
    _loadFinanceData();
    _finance_Goals = fetch_finance_Goals();

  }
  Future<List<Map<String, dynamic>>> fetch_finance_Goals()async{
    final db = await DatabaseHelper().database;
    return await db.query(
      'goals',
      where: 'category = ?',
      whereArgs: ['Finances'],
      orderBy: 'start_date DESC',
    );
  }
  Future<void> _loadFinanceData() async {
    final db = await DatabaseHelper().database;
    final results = await db.query('finances');

    final Map<String, int> dailyChanges = {};
    for (var row in results) {
      final date = DateTime.parse(row['datetime'] as String);
      final dayKey =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      final amount = row['finance_amount'] as int;
      dailyChanges.update(dayKey, (value) => value + amount,
          ifAbsent: () => amount);
    }

    setState(() {
      financeData = dailyChanges;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: selectedFinancePage ??
          Row(children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FinanceLineChart(),
                    FinanceCategoryPieChart()
                  ],
                ),
              ),
            ),
            FutureBuilder(
                future: _finance_Goals,
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
                    return const Center(child: Text('No Finance goals have been made.'));}
                  final goals = snapshot.data!;
                  return
                    Expanded(child:
                    ListView.builder(
                        itemCount: goals.length,
                        itemBuilder: (context, i){
                          final goal = goals[i];
                          return Card(
                            child: ListTile(
                              title: Text(goal['goal_content'] ?? 'N/A'),
                              onTap: (){
                                setState(() {
                                  selectedFinancePage = NewGoalContent(
                                    LastPage: this.widget,
                                    id: goal['id'],
                                    category: "Finances",
                                    title: goal['title'],
                                    start_date: goal['start_date'],
                                    end_date: goal['end_date'],
                                    time_of_day: goal['time_of_day'],
                                    frequency_amount: goal['frequency_amount'],
                                    frequency_time: goal['frequency_time'],
                                    goal_content: goal['goal_content'],
                                    goal_complete: goal['goal_complete'],
                                  );
                                });
                              }
                            ),
                          );
                        }
                    ));
                }
            ),
            Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedFinancePage = NewGoalContent(
                          LastPage: widget,
                          id: null,
                          category: "Finances",
                          title: null,
                          start_date: null,
                          end_date: null,
                          time_of_day: null,
                          frequency_amount: null,
                          frequency_time: null,
                          goal_content: null,
                          goal_complete: null,
                        );
                      });
                    },
                    child: Text('New Finance Goal')),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedFinancePage = FinancePaymentContent(
                          id: null,
                          finance_category: null,
                          datetime: null,
                          finance_amount: null,
                          finance_note: null,
                        );
                      });
                    },
                    child: Text('New Payment')),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedFinancePage = Finance_Data_Content();
                      });
                    },
                    child: Text('View Payments')),
              ],
            )
          ]),
    );
  }
}
