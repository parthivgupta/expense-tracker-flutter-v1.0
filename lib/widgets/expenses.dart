
import 'dart:math';

import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Flutter course',
        date: DateTime.now(),
        amount: 19.99,
        category: Category.work),
    Expense(
        title: 'Cinema',
        date: DateTime.now(),
        amount: 15.69,
        category: Category.leisure)
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) => NewExpense(onAddExpense: _addExpense));
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: const Text('deleted expense'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  @override
  Widget build(context) {
    Widget mainContent = const Center(
      child: Text("No expenses has been found"),
    );
    if (_registeredExpenses.isNotEmpty) {
      mainContent = Expanded(
          child: ExpensesList(
              expenses: _registeredExpenses, onRemoveExpense: _removeExpense));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Expense tracker'),
        actions: [
          IconButton(
              onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          Chart(expenses: _registeredExpenses),
          mainContent,
        ],
      ),
    );
  }
}
