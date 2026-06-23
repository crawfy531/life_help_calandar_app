
import 'package:flutter/material.dart';


// Custom Widgets

// Data

// Finance
import 'package:life_help_calandar_project/finance/finance_page.dart';

// Goal
import 'package:life_help_calandar_project/goal/goal_page.dart';

// Health - Exercise

// Health - Nutrition

// Health - General
import 'package:life_help_calandar_project/health/health_page.dart';

// Home
import 'package:life_help_calandar_project/home/home_page.dart';

// Main Layout & Entry Point

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}



class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePageContent(),
    HealthPageContent(),
    FinancePageContent(),
    GoalPageContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Life Help Calendar'),
      ),
      body: Row(
        children: [
          // Scrollable NavigationRail
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: NavigationRail(
                      selectedIndex: _selectedIndex,
                      onDestinationSelected: (int index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      labelType: NavigationRailLabelType.all,
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.home),
                          label: Text('Home'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.favorite),
                          label: Text('Health'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.attach_money),
                          label: Text('Finance'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.flag),
                          label: Text('Goals'),
                        ),
                        // Add more destinations if needed
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Page content
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}