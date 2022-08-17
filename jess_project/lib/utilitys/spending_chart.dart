import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jess_project/screens/home.dart';

import 'item_model.dart';

class SpendingChart extends StatelessWidget {
  final List<Item> items;
  const SpendingChart({
    Key key,
    this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spending = <String, double>{};

    items.forEach((item) => spending.update(
        item.category, (value) => value + item.price,
        ifAbsent: () => item.price));
    return Card(
        margin: const EdgeInsets.all(8.0),
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          height: 360.0,
          child: Column(
            children: [
              Expanded(
                child: PieChart(
                  PieChartData(
                    sections: spending
                        .map((category, amountSpent) => MapEntry(
                              category,
                              PieChartSectionData(
                                  color: getCategoryColor(category),
                                  radius: 100.0,
                                  title: '\$${amountSpent.toStringAsFixed(2)}',
                                  value: amountSpent),
                            ))
                        .values
                        .toList(),
                    sectionsSpace: 0,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: spending.keys
                    .map((category) => _Indicator(
                          color: getCategoryColor(category),
                          text: category,
                        ))
                    .toList(),
              )
            ],
          ),
        ));
  }
}

class _Indicator extends StatelessWidget {
  final Color color;
  final String text;

  const _Indicator({
    Key key,
    this.color,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 15.0,
          width: 15.0,
          color: color,
        ),
        const SizedBox(
          width: 5.0,
        ),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w400))
      ],
    );
  }
}
