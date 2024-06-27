import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppIcons{
  final List<Map<String, dynamic>> homeExpenseCategories = [
    {
      "name": "All",
      "icon": FontAwesomeIcons.borderAll,
    },
    {
      "name": "Personal",
      "icon": FontAwesomeIcons.personCirclePlus,
    },
    {
      "name": "Salary",
      "icon": FontAwesomeIcons.indianRupeeSign,
    },
    {
      "name": "Grocery",
      "icon": FontAwesomeIcons.cartShopping,
    },
    {
      "name": "Vegetables",
      "icon": FontAwesomeIcons.carrot,
    },
    {
      "name": "Fruits",
      "icon": FontAwesomeIcons.appleWhole,
    },
    {
      "name": "Gas Filling",
      "icon": FontAwesomeIcons.gasPump,
    },
    {
      "name": "Milk",
      "icon": FontAwesomeIcons.mugHot,
    },
    {
      "name": "Internet",
      "icon": FontAwesomeIcons.wifi,
    },
    {
      "name": "Water",
      "icon": FontAwesomeIcons.droplet,
    },
    {
      "name": "Electricity",
      "icon": FontAwesomeIcons.bolt,
    },
    {
      "name": "Rent",
      "icon": FontAwesomeIcons.house,
    },
    {
      "name": "Phone Bill",
      "icon": FontAwesomeIcons.phone,
    },
    {
      "name": "Foods & Drinks",
      "icon": FontAwesomeIcons.utensils,
    },
    {
      "name": "Entertainment",
      "icon": FontAwesomeIcons.film,
    },
    {
      "name": "Healthcare",
      "icon": FontAwesomeIcons.notesMedical,
    },
    {
      "name": "Transportation",
      "icon": FontAwesomeIcons.busSimple,
    },
    {
      "name": "Clothing",
      "icon": FontAwesomeIcons.shirt,
    },
    {
      "name": "Insurance",
      "icon": FontAwesomeIcons.shieldHalved,
    },
    {
      "name": "Education",
      "icon": FontAwesomeIcons.graduationCap,
    },
    {
      "name": "Other",
      "icon": FontAwesomeIcons.listUl,
    },
  ];
  IconData getExpenseCategoryIcons(String categoryName) {
    final category = homeExpenseCategories.firstWhere(
      (category) => category['name'] == categoryName,
      orElse: () => {"icon":FontAwesomeIcons.buromobelexperte}
    );
    return category['icon'];
  }
}