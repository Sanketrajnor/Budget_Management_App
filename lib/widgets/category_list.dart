import 'package:budget_tracker/utils/icons_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key, required this.onChanged});
  final ValueChanged<String?> onChanged;

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {

  String currentCategory = "All";
  List<Map<String, dynamic>> categoryList = [];
  final scrollController = ScrollController();

  var appIcons = AppIcons();

  var addCat = {
    "name": "All",
    "icon": FontAwesomeIcons.borderAll,
  };

  @override
  void initState() {
    super.initState();
    setState(() {
      categoryList = appIcons.homeExpenseCategories;
      if (!categoryList.any((category) => category['name'] == 'All')) {
        categoryList.insert(0, addCat);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.builder(
        controller: scrollController,
        itemCount: categoryList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index){
          var data = categoryList[index];
          return GestureDetector(
            onTap: (){
              setState(() {
                currentCategory = data['name'];
                widget.onChanged(data['name']);
              });
            },
            child: Container(
              margin: EdgeInsets.all(6),
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                color: currentCategory == data['name'] 
                ?  Colors.blue.shade900 :
                Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20)
                ),
              child: Center(
                child: Row(
                  children: [
                    Icon(
                      data['icon'],
                      size: 15,
                      color: currentCategory == data['name']
                      ? Colors.white
                      : Colors.blue.shade900,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      data['name'],
                       style: TextStyle(
                    color : currentCategory == data['name'] 
                    ?  Colors.white :
                    Colors.blue.shade900,
                                  ),),
                  ],
                )),
            ),
          );
        }
        ),
    );
  }
}