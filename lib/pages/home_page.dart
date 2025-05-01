import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7A1FA2),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 200,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Hello, John!",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Welcome Back To DoKo",
                            style: TextStyle(
                                color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                      Icon(Icons.notifications_none, color: Colors.white),
                    ],
                  ),
                  SizedBox(height: 16),
          
                  Spacer(), 
              
                  // Month navigation with arrows
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.chevron_left, color: Colors.white),
                          onPressed: () {},
                        ),
                        Column(
                          children: const [
                            Text(
                              "April",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "2025",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.chevron_right, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    // Kalender
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      child: buildCalendar(),
                    ),
                    
                    // Task List
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Task List",
                          style: TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7A1FA2)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          buildTaskCard(
                            title: "PPT Fuzzy Logic",
                            time: "Today, 9.00 AM",
                            progress: 0.8,
                            percentage: "80%",
                          ),
                          buildTaskCard(
                            title: "Task",
                            time: "Today, 9.00 AM",
                            progress: 0.4,
                            percentage: "40%",
                            progressColor: Colors.amber,
                          ),
                          buildTaskCard(
                            title: "Task",
                            time: "Today, 9.00 AM",
                            progress: 0.6,
                            percentage: "60%",
                            progressColor: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF7A1FA2),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view), label: "Group"),
        ],
      ),
    );
  }
Widget buildCalendar() {
  List<String> days = ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'];

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Column(
      children: [
        // Day headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: days.map((day) => Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
          )).toList(),
        ),
        SizedBox(height: 8),
        // Calendar dates
        Column(
          children: [
            buildCalendarRow([1, 2, 3, 4, 5, 6, 7]),
            buildCalendarRow([8, 9, 10, 11, 12, 13, 14]),
            buildCalendarRow([15, 16, 17, 18, 19, 20, 21]),
            buildCalendarRow([22, 23, 24, 25, 26, 27, 28]),
            buildCalendarRow([29, 30, null, null, null, null, null]),
          ],
        ),
      ],
    ),
  );
}
  Widget buildCalendarRow(List<int?> days) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: days.map((day) {
        if (day == null) {
          return Expanded(child: Container());
        }
        
        bool isSelected = day == 17;
        bool hasUnderline = day == 18 || day == 19 || day == 20 || day == 24;
        
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFF7A1FA2) : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Text(
                      '$day',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (hasUnderline)
                  Container(
                    height: 2,
                    width: 16,
                    color: Color(0xFF7A1FA2),
                    margin: EdgeInsets.only(top: 2),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildTaskCard({
    required String title,
    required String time,
    required double progress,
    required String percentage,
    Color progressColor = Colors.green,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xFF7A1FA2),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "in 2 hours",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300],
                      color: progressColor,
                      minHeight: 10,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  percentage,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}