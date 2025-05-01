import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Add Title...',
                    hintStyle: TextStyle(
                      color: const Color.fromARGB(255, 169, 169, 169),
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      height: 1.5,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                  style: TextStyle(color: Color.fromARGB(255, 169, 169, 169)),
                ),
                SizedBox(height: 16),
                ListTile(
                  leading: Icon(
                    Icons.alarm,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  title: Text(
                    'Reminder',
                    style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                  ),
                  trailing: Text(
                    'Once',
                    style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.calendar_today,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  title: Text(
                    'Deadline',
                    style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                  ),
                  trailing: Text(
                    'Eee, dd MMM yyyy',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 169, 169, 169),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.note,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  title: Text(
                    'Add Notes...',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 169, 169, 169),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.attach_file,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  title: Text(
                    'Add Attachment...',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 169, 169, 169),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 126, 26, 209),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        //head bar
        preferredSize: Size.fromHeight(150),
        child: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  //gradasi
                  Color.fromARGB(255, 207, 177, 231),
                  Color.fromARGB(255, 83, 33, 153),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kecerdasan Buatan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'This library contains AI notes',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white, // Kalender kotak putih
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(77),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // bayangan kecil
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'April 2025',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(255, 126, 26, 209),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white, // Kotak putih kosong
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        //tanda + button
        onPressed: () => _showAddTaskBottomSheet(context),
        backgroundColor: Color.fromARGB(255, 126, 26, 209),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
