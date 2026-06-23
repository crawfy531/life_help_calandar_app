
import 'package:flutter/material.dart';


// Custom Widgets

// Data

// Finance
import 'package:life_help_calandar_project/finance/finance_page.dart';

// Goal

// Health - Exercise

// Health - Nutrition

// Health - General

// Home

// Main Layout & Entry Point

class FinanceExpenseContent extends StatefulWidget {
  const FinanceExpenseContent({super.key});

  @override
  _FinanceExpenseContentState createState() => _FinanceExpenseContentState();
}

class _FinanceExpenseContentState extends State<FinanceExpenseContent> {

  Widget? selectedFinancePage;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: selectedFinancePage ?? Column(
          children: [
            ElevatedButton(
                onPressed:(){
                  setState((){
                    selectedFinancePage = FinancePageContent();
                  });
                },
                child: Text('back')),
            ElevatedButton(
                onPressed:(){
                  setState((){
                    selectedFinancePage = FinancePageContent();
                  });
                },
                child: Text('record transaction')),
          ],
        )
    );
  }
}
