import 'package:enum_to_string/enum_to_string.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:stock_scrapper/providers/product.dart';

class FilterButton extends StatefulWidget {
  final Function(List<String>) onApply;
  final List<String> selectedCountList;
  final List<String> enumValues;
  final String title;
  final String headlineText;

  FilterButton({
    @required this.onApply,
    @required this.selectedCountList,
    @required this.enumValues,
    @required this.title,
    this.headlineText = "Select Items",
  });

  @override
  _FilterButtonState createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  void _openFilterDialog() async {
    await FilterListDialog.display(context,
        allTextList: widget.enumValues,
        height: 480,
        borderRadius: 20,
        headlineText: widget.headlineText,
        searchFieldHintText: "Search Here",
        backgroundColor: Theme.of(context).backgroundColor,
        headerTextColor: Theme.of(context).textSelectionColor,
        closeIconColor: Theme.of(context).textSelectionColor,
        selectedTextList: widget.selectedCountList, onApplyButtonClick: (list) {
      if (list != null) {
        setState(() {
          widget.onApply(list);
        });
      }
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        widget.title,
        style: TextStyle(fontSize: 20),
      ),
      onPressed: _openFilterDialog,
    );
  }
}
