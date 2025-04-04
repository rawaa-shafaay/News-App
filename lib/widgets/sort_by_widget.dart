import 'package:flutter/material.dart';
import 'package:sample/enums/sort_by.dart';

class SortByWidget extends StatefulWidget {
  const SortByWidget({super.key});

  @override
  State<SortByWidget> createState() => _SortByWidgetState();
}

class _SortByWidgetState extends State<SortByWidget> {
  SortBy _selectedSortBy = SortBy.publishedAt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButtonFormField<SortBy>(
        decoration: InputDecoration(
          labelText: 'Sort by',
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        value: _selectedSortBy,
        items: _dropDownMenuItems(),
        onChanged: (value) {
          setState(() {
            _selectedSortBy = value!;
          });
        },
      ),
    );
  }

  List<DropdownMenuItem<SortBy>> _dropDownMenuItems() {
    return SortBy.values
        .map((item) => DropdownMenuItem(value: item, child: Text(item.name)))
        .toList();
  }
}
