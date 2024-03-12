import 'package:mysql1/mysql1.dart';

Future<void> updateData() async {
  // Establish a connection to the MySQL database
  final conn = await MySqlConnection.connect(
    ConnectionSettings(
      host: '143.198.202.68',
      port: 3306,
      user: 'admin',
      password: 'admin4321',
      db: 'slt-face',
    ),
  );

  try {
    // Execute SQL query to update data in the database
    await conn.query(
        'UPDATE your_table SET column1 = ?, column2 = ? WHERE id = ?',
        ['new_value1', 'new_value2', 123]);

    print('Data updated successfully');
  } catch (e) {
    // Handle any errors that occur during the database operation
    print('Error updating data: $e');
  } finally {
    // Close the database connection
    await conn.close();
  }
}
