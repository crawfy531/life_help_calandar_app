import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Custom Widgets
import 'package:life_help_calandar_project/custom_widgets/date_dropdown_selector.dart';
import 'package:life_help_calandar_project/data/user_database.dart';

// Health - Nutrition
import 'package:life_help_calandar_project/health/nutrition/nutrition_page.dart';
import 'package:life_help_calandar_project/health/nutrition/insert_nutrition_data.dart';

class Nutrient {
  final String name;
  final double value;
  final String unit;

  Nutrient({required this.name, required this.value, required this.unit});
}

class NutritionManualEntryPageContent extends StatefulWidget {
  final int? id;
  final String? date;
  final int? serving_number;
  final String? food;
  final String? food_category;
  final String? ingredients;
  final int? serving_size;
  final String? serving_unit;
  final String? serving_description;
  final String? nutrients;

  const NutritionManualEntryPageContent({
    super.key,
    required this.id,
    required this.date,
    required this.serving_number,
    required this.food,
    required this.ingredients,
    required this.food_category,
    required this.serving_size,
    required this.serving_unit,
    this.serving_description,
    this.nutrients,
  });

  @override
  _NutritionManualEntryPageContentState createState() =>
      _NutritionManualEntryPageContentState();
}

class _NutritionManualEntryPageContentState
    extends State<NutritionManualEntryPageContent> {
  final description = TextEditingController();
  final servingSize = TextEditingController();
  final servingUnit = TextEditingController();
  final foodCategory = TextEditingController();
  final servingText = TextEditingController();
  final servingAmount = TextEditingController();

  final nutrientName = TextEditingController();
  final nutrientValue = TextEditingController();
  final nutrientUnit = TextEditingController();

  final ingredient = TextEditingController();

  Widget? selectedHealthPage;

  List<Nutrient> nutrients = [];
  List<String> ingredients = [];
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();

    description.text = widget.food ?? '';
    foodCategory.text = widget.food_category ?? '';
    servingSize.text =  widget.serving_size?.toString()?? '';
    servingUnit.text =  widget.serving_description ?? '';
    servingText.text =  widget.serving_unit  ?? '';
    servingAmount.text = widget.serving_number?.toString() ?? '';

    selectedDate = DateTime.tryParse(widget.date ?? '') ?? DateTime.now();

    if (widget.ingredients != null && widget.ingredients!.trim().isNotEmpty) {
      ingredients = widget.ingredients!
          .replaceAll(RegExp(r'\[|\]'), '')
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }

    if (widget.nutrients != null && widget.nutrients!.trim().isNotEmpty) {
      try {
        final parsed = jsonDecode(widget.nutrients!);
        if (parsed is List) {
          nutrients = parsed
              .map((item) => Nutrient(
            name: item['nutrientName'] ?? '',
            value: (item['value'] ?? 0).toDouble(),
            unit: item['unitName'] ?? '',
          ))
              .toList();
        }
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    description.dispose();
    servingSize.dispose();
    servingUnit.dispose();
    foodCategory.dispose();
    servingText.dispose();
    servingAmount.dispose();
    nutrientName.dispose();
    nutrientValue.dispose();
    nutrientUnit.dispose();
    ingredient.dispose();
    super.dispose();
  }

  Widget buildTextField(TextEditingController controller,
      {bool digitsOnly = false}) {
    return Expanded(
      child: TextField(
        controller: controller,
        keyboardType:
        digitsOnly ? TextInputType.number : TextInputType.text,
        inputFormatters:
        digitsOnly ? [FilteringTextInputFormatter.digitsOnly] : [],
      ),
    );
  }

  void addNutrient() {
    final name = nutrientName.text;
    final value = double.tryParse(nutrientValue.text);
    final unit = nutrientUnit.text;

    if (name.isNotEmpty && value != null && unit.isNotEmpty) {
      setState(() {
        nutrients.add(Nutrient(name: name, value: value, unit: unit));
        nutrientName.clear();
        nutrientValue.clear();
        nutrientUnit.clear();
      });
    }
  }

  void addIngredient() {
    final text = ingredient.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        ingredients.add(text);
        ingredient.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return selectedHealthPage ??
        SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  DateDropdownSelector(
                      initialDate: selectedDate,
                      onDateChanged: (date) {
                        setState(() {
                          selectedDate = date;
                        });
                      }),
                  Text('Servings consumed:'),
                  buildTextField(servingAmount, digitsOnly: true),
                ],
              ),
              Row(
                children: [
                  Text('Description:'),
                  buildTextField(description),
                  Text('Food Category:'),
                  buildTextField(foodCategory),
                ],
              ),
              Row(children: [
                Text("Ingredients:"),
                Expanded(child: buildTextField(ingredient)),
                ElevatedButton(
                  onPressed: addIngredient,
                  child: Text("Add"),
                ),
              ]),
              if (ingredients.isNotEmpty)
                ...ingredients.map((i) => ListTile(
                    title: Text(i),
                    trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () =>
                            setState(() => ingredients.remove(i))))),
              Row(
                children: [
                  Text('Serving Size:'),
                  buildTextField(servingSize),
                  Text('Serving Size Unit:'),
                  buildTextField(servingUnit),
                ],
              ),
              Row(
                children: [
                  Text('Serving Description:'),
                  buildTextField(servingText),
                ],
              ),
              Text("Add Nutrient:"),
              Row(children: [
                Text('Nutrient Name:'),
                buildTextField(nutrientName),
              ]),
              Row(
                children: [
                  Text('Nutrient Value:'),
                  buildTextField(nutrientValue, digitsOnly: true),
                  Text('Nutrient Unit:'),
                  buildTextField(nutrientUnit),
                  ElevatedButton(
                    onPressed: addNutrient,
                    child: Text("Add Nutrient"),
                  ),
                ],
              ),
              Text("Nutrients:"),
              ...nutrients.map((n) => ListTile(
                title: Text(n.name),
                subtitle: Text("${n.value} ${n.unit}"),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () =>
                      setState(() => nutrients.remove(n)),
                ),
              )),
              ElevatedButton(
                onPressed: () {
                  if (description.text.isNotEmpty &&
                      foodCategory.text.isNotEmpty &&
                      servingAmount.text.isNotEmpty &&
                      servingSize.text.isNotEmpty &&
                      servingUnit.text.isNotEmpty) {
                    prep_nutrition_data(
                      widget.id,
                      selectedDate,
                      servingAmount.text,
                      description.text,
                      foodCategory.text,
                      ingredients,
                      servingSize.text,
                      servingUnit.text,
                      servingText.text,
                      nutrients,
                    );
                    setState(() {
                      selectedHealthPage = NutritionPageContent();
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill all required fields.')),
                    );
                  }
                },
                child: Text("Submit"),
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedHealthPage = NutritionPageContent();
                    });
                  },
                  child: Text('Back')),
              ElevatedButton(
                  onPressed:(){
                    setState((){
                      if(widget.id!= null){
                        deleteItem("nutrition", widget.id!);
                      }
                      selectedHealthPage = NutritionPageContent();
                      ;});
                  },
                  child: Text('Delete')),

            ],
          ),
        );
  }
}
