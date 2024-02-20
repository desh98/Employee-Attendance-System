import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  List<Map<String, dynamic>> tableData = []; // Variable to store table data

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the screen initializes
  }

  Future<void> fetchData() async {
    try {
      final response = await http.post(
        Uri.parse('https://ientrada.raccoon-ai.io/api/data'),
        headers: <String, String>{
          'accept': 'application/json',
          'api': 'abcd',
          'user': 'slt',
        },
        body: <String, String>{},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Print response data
        print('Response Data: $responseData');
        setState(() {
          // Update tableData based on responseData
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome to Ientrada',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'The Embryo Employee Entering and Exiting System.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 25),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue[200],
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total Users | Total Registrations',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '136 | 45',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.purple[200],
                    ),
                    child: Icon(
                      Icons.warning_rounded,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Incomplete Registrations',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '37',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Display API response data
            Text(
              'Employees',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            // Add a table to display the fetched data
            DataTable(
              columns: [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Now')),
                DataColumn(label: Text('Registration')),
              ],
              rows: tableData.map((data) {
                return DataRow(cells: [
                  DataCell(Text(data['userID'].toString())),
                  DataCell(Text(data['now'].toString())),
                  DataCell(Text(data['registration'].toString())),
                ]);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
