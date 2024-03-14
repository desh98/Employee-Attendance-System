import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ientrada_new/constants/api.dart';
import 'package:ientrada_new/constants/color.dart';
import 'package:ientrada_new/widgets/appbar.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final String apiUrl =
      '${ApiConstants.apiUrl}${ApiConstants.dashboardDataEndpoint}';

  List<dynamic> employeeData = [];
  bool isSheetExpanded = false;
  int userCount = 137;
  int regCount = 15;
  int incReg = 12;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchUserCount();
    fetchRegCount();
    fetchIncReg();
  }

  Future<void> fetchUserData() async {
    try {
      // Create a POST request
      var request = http.Request('POST', Uri.parse(apiUrl));

      // Add headers
      request.headers['api'] = ApiConstants.apiKey;
      request.headers['user'] = ApiConstants.user;
      request.headers['other'] = 'user_data';

      // Send the request and await the response
      http.StreamedResponse response = await request.send();

      // Get the response body
      String responseBody = await response.stream.bytesToString();

      // Parse the response JSON based on dataType
      setState(() {
        employeeData = json.decode(responseBody);
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> fetchUserCount() async {
    try {
      // Create a POST request
      var request = http.Request('POST', Uri.parse(apiUrl));

      // Add headers
      request.headers['api'] = ApiConstants.apiKey;
      request.headers['user'] = ApiConstants.user;
      request.headers['other'] = 'user_count';

      // Send the request and await the response
      http.StreamedResponse response = await request.send();

      // Get the response body
      String responseBody = await response.stream.bytesToString();

      // Parse the response JSON based on dataType
      setState(() {
        userCount = int.parse(responseBody);
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> fetchRegCount() async {
    try {
      // Create a POST request
      var request = http.Request('POST', Uri.parse(apiUrl));

      // Add headers
      request.headers['api'] = ApiConstants.apiKey;
      request.headers['user'] = ApiConstants.user;
      request.headers['other'] = 'reg_count';

      // Send the request and await the response
      http.StreamedResponse response = await request.send();

      // Get the response body
      String responseBody = await response.stream.bytesToString();

      // Parse the response JSON based on dataType
      setState(() {
        regCount = int.parse(responseBody);
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> fetchIncReg() async {
    try {
      // Create a POST request
      var request = http.Request('POST', Uri.parse(apiUrl));

      // Add headers
      request.headers['api'] = ApiConstants.apiKey;
      request.headers['user'] = ApiConstants.user;
      request.headers['other'] = 'inc_reg';

      // Send the request and await the response
      http.StreamedResponse response = await request.send();

      // Get the response body
      String responseBody = await response.stream.bytesToString();

      // Parse the response JSON based on dataType
      setState(() {
        incReg = int.parse(responseBody);
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Welcome to Ientrada',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'The Embryo Employee Entering and Exiting System.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSub,
                            ),
                          ),
                          SizedBox(height: 25),
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.secondaryDark,
                                  ),
                                  child: Icon(
                                    Icons.people,
                                    color: Colors.white,
                                    size: 18,
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
                                      '$regCount | $userCount',
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
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryDark,
                                  ),
                                  child: Icon(
                                    Icons
                                        .system_security_update_warning_rounded,
                                    color: Colors.white,
                                    size: 18,
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
                                      '$incReg',
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: DraggableScrollableSheet(
          initialChildSize: 1.0,
          minChildSize: 1.0,
          maxChildSize: 1.0,
          expand: true,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isSheetExpanded = !isSheetExpanded;
                        });
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Employees',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Icon(
                              isSheetExpanded
                                  ? Icons.arrow_drop_down_rounded
                                  : Icons.arrow_drop_up_rounded,
                              color: Colors.black,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(color: AppColors.white),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Table(
                            border: TableBorder.all(
                                color: Colors.grey.shade300, width: 1.0),
                            columnWidths: {
                              0: FlexColumnWidth(3),
                              1: FlexColumnWidth(2),
                              2: FlexColumnWidth(1),
                            },
                            children: [
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                ),
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          'User',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          'Status',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          'No',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Data rows
                              for (var rowData in employeeData)
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(rowData[0].toString()),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            rowData[1] == 'i'
                                                ? 'Entered'
                                                : 'Exited',
                                            style: TextStyle(
                                              color: rowData[1] == 'i'
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
                                            child: Text(rowData[2].toString())),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
