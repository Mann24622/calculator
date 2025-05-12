import 'package:calculator/model/calculation.dart';
import 'package:calculator/sqlite/database%20helper.dart';
import 'package:flutter/material.dart';
import 'package:calculator/calculator.dart';

class FirstPage extends StatefulWidget {
  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  List<CalculationHistory> myData = [];
  bool _isLoading = true;

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _fetchData(); 
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });
    myData = await _databaseHelper.getCalculations(); // Fetch calculations from the database
    setState(() {
      _isLoading = false; // Set loading state to false after fetching
    });
  }

  Future<void> deleteCalculations(int id) async {
    await _databaseHelper.deleteCalculation(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted!'),
      backgroundColor: Colors.green,
    ));
    _fetchData(); // Refresh the data
  }

  void calculator(int? id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalculatorPage(),
      ),
    ).then((_) {
      _fetchData(); // Refresh data when returning
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator History'),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : myData.isEmpty
          ? const Center(child: Text("No Data Available!!!"))
          : ListView.builder(
        itemCount: myData.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(myData[index].id.toString()),
            direction: DismissDirection.horizontal,
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                // User swiped left to delete
                deleteCalculations(myData[index].id!);
              } else if (direction == DismissDirection.startToEnd) {
                // User swiped right to edit
                calculator(myData[index].id);
              }
            },
            background: slideLeftBackground(),
            secondaryBackground: slideRightBackground(),
            child: Card(
              color: index % 2 == 0 ? Colors.green : Colors.green[200],
              margin: const EdgeInsets.all(15),
              child: ListTile(
                title: Row(
                  children: [
                    Expanded(child: Text(myData[index].equation)), // Display equation
                    const SizedBox(width: 50),
                    Expanded(child: Text(myData[index].result)), // Display result
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
        onPressed: () {
          calculator(null); // Navigate to CalculatorPage to add new calculation
        },
      ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.red,
      child: const Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 20),
            Icon(Icons.delete, color: Colors.white),
            Text(
              " delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.blue,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            const Icon(Icons.edit, color: Colors.white),
            const Text(
              " edit",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(width: 20),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
}
