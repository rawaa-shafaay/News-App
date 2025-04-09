import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/enums/sort_by.dart';
import 'package:sample/providers/news_provider.dart';

class SortByWidget extends StatefulWidget {
  const SortByWidget({super.key});

  @override
  State<SortByWidget> createState() => _SortByWidgetState();
}

class _SortByWidgetState extends State<SortByWidget> {
  late SortBy _selectedSortBy;
  late NewsProvider _newsProvider;

  @override
  void initState() {
    super.initState();
    _newsProvider = context.read<NewsProvider>();
    _selectedSortBy = _mapStringToSortBy(_newsProvider.sortBy);
  }

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
          if (value != null && value != _selectedSortBy) {
            setState(() {
              _selectedSortBy = value;
            });
          }
          _newsProvider.setSortBy(value!.name);
        },
      ),
    );
  }

  List<DropdownMenuItem<SortBy>> _dropDownMenuItems() {
    return SortBy.values
        .map((item) => DropdownMenuItem(value: item, child: Text(item.name)))
        .toList();
  }

  SortBy _mapStringToSortBy(String value) {
    return SortBy.values.firstWhere(
      (e) => e.name == value,
      orElse: () => SortBy.publishedAt, // default fallback
    );
  }
}
