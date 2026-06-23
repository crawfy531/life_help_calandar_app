
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:life_help_calandar_project/custom_widgets/date_dropdown_selector.dart';
import 'package:life_help_calandar_project/data/user_database.dart';

import 'package:life_help_calandar_project/finance/finance_page.dart';
import 'package:life_help_calandar_project/finance/insert_finances.dart';


class FinancePaymentContent extends StatefulWidget {
  const FinancePaymentContent({super.key, required this.id, required this.finance_category, required this.datetime, required this.finance_amount, required this.finance_note});
  final int? id;
  final String? finance_category;
  final String? datetime;
  final int? finance_amount;
  final String? finance_note;

  @override
  _FinancePaymentContentState createState() => _FinancePaymentContentState();
}

class _FinancePaymentContentState extends State<FinancePaymentContent> {
  final category_controller = TextEditingController();
  final finance_amount_controller = TextEditingController();
  final finance_note_controller = TextEditingController();
  late DateTime? selected_date;
  bool payment = false;
  Widget? selectedFinancePage;
  // null, category_controller.text, selected_date!, finance_amount_controller.text, payment, finance_note_controller.text
  @override
  void initState(){
    super.initState();

    // Safely assign category
    category_controller.text = widget.finance_category ?? '';

    // Try parsing the datetime safely
    selected_date = DateTime.tryParse(widget.datetime ?? '') ?? DateTime.now();

    // Handle negative/positive finance_amount and convert to absolute string
    final amount = widget.finance_amount ?? 0;
    payment = amount < 0;
    finance_amount_controller.text = amount.abs().toString();

    // Safe note assignment
    finance_note_controller.text = widget.finance_note ?? '';

  }
  @override
  Widget build(BuildContext context) {
    return Center(
        child: selectedFinancePage ?? SingleChildScrollView( child: Column(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    // datetime TEXT,
                    Text('Date of Gain/Loss:'),
                    DateDropdownSelector(
                      initialDate: selected_date,
                      onDateChanged: (date){
                        setState(() {
                          selected_date = date;
                        });
                      },
                    ),

                  ],
                ),
                Row(
                  children: [
                    // finance_category TEXT
                    Text('Category:'),
                    Expanded(
                        child: TextField(
                          controller: category_controller,
                          maxLength: 10,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        )
                    ),
                    Text('Loss?:'),
                    Checkbox(
                        value: payment,
                        onChanged: (bool? change){
                          setState(() {
                            payment = change!;
                          });
                        }
                    ),
                    // finance_amount INTEGER,
                    Text('Total Amount:'),
                    Expanded(
                        child: TextField(
                            keyboardType: TextInputType.number,
                            controller: finance_amount_controller,
                            maxLength: 10,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ]
                        )
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("Note for this Entry:"),
                    Expanded(
                      child: TextField(
                        controller: finance_note_controller,
                        maxLength: 200,
                        maxLines: 5,
                        minLines: 1,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      )
                  )],
                ),


              ],
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed:(){
                      setState((){
                        if (selected_date != null){
                        prep_financial_data(widget.id, category_controller.text, selected_date!, finance_amount_controller.text, payment, finance_note_controller.text);
                        selectedFinancePage = FinancePageContent();
                        }
                      });
                    },
                    child: Text('Submit')),
                ElevatedButton(
                    onPressed:(){
                      setState((){
                        selectedFinancePage = FinancePageContent();
                      });
                    },
                    child: Text('Back')),
                ElevatedButton(
                    onPressed:(){
                      setState((){
                        if(widget.id!= null){
                          deleteItem("finances", widget.id!);
                        }
                        selectedFinancePage = FinancePageContent();
                      });
                    },
                    child: Text('Delete')),
              ],
            )

          ],
        )
    ));
  }
}