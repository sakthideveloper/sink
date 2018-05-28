import 'package:flutter/material.dart';
import 'package:sink/domain/expense.dart';
import 'package:sink/exceptions/InvalidInput.dart';
import 'package:sink/ui/date_picker.dart';
import 'package:sink/utils/validations.dart';

class ExpenseForm extends StatefulWidget {
  @override
  ExpenseFormState createState() {
    return ExpenseFormState();
  }
}

class ExpenseFormState extends State<ExpenseForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime _initialDate = DateTime.now();

  String _description;
  double _cost;
  String _category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Expense')),
      body: Builder(
        builder: (BuildContext context) {
          return Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                DatePicker(
                  labelText: 'From',
                  selectedDate: _initialDate,
                  onChanged: ((DateTime date) {
                    setState(() {
                      _initialDate = date;
                    });
                  }),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Price"),
                  keyboardType: TextInputType.number,
                  validator: (value) => _validatePrice(value),
                  onSaved: (value) => _cost = double.parse(value),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Category"),
                  validator: (value) => _validateNotEmpty(value),
                  onSaved: (value) => _category = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Description"),
                  validator: (value) => _validateNotEmpty(value),
                  onSaved: (value) => _description = value,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            Navigator.of(context).pop(Expense(
                                cost: _cost,
                                date: _initialDate,
                                category: _category,
                                description: _description));
                          }
                        },
                        child: Text('Save'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _validateNotEmpty(String value) {
    try {
      notEmpty(value);
      return null;
    } on InvalidInput catch (e) {
      return e.cause;
    }
  }

  String _validatePrice(String value) {
    try {
      nonNegative(value);
      return null;
    } on InvalidInput catch (e) {
      return e.cause;
    }
  }
}
