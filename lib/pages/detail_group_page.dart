import 'package:doko/components/task_card.dart';
import 'package:flutter/material.dart';

class DetailGroupPage extends StatelessWidget {
  final List<Color> cardColors = [
    Color(0xFF7E1AD1),
    Color(0xFFBD00F2),
    Color(0xFFD239E0),
    Color(0xFFE045B1),
  ];

  final List<Map<String, String>> dummyTasks = [
    {
      'time': '08:00',
      'title': 'Tugas 6: Algoritma Genetika',
      'desc':
          'Menyesuaikan PPT Menyesuaikan PPT  Menyesuaikan PPT  Menyesuaikan PPT  Menyesuaikan PPT Menyesuaikan PPT  Menyesuaikan PPT  Menyesuaikan PPT ',
    },
    {
      'time': '09:00',
      'title': 'Tugas 6: Algoritma Genetika',
      'desc': 'Menyesuaikan PPT',
    },
    {
      'time': '10:00',
      'title': 'Tugas 6: Algoritma Genetika',
      'desc': 'Menyesuaikan PPT',
    },
    {
      'time': '11:00',
      'title': 'Tugas 6: Algoritma Genetika',
      'desc': 'Menyesuaikan PPT',
    },
    {
      'time': '07:00',
      'title': 'Tugas 6: Algoritma Genetika',
      'desc':
          'Menyesuaikan PPT Menyesuaikan PPT  Menyesuaikan PPT  Menyesuaikan PPT  Menyesuaikan PPT Menyesuaikan PPT  Menyesuaikan PPT  Menyesuaikan PPT ',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 185,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFCFB1E7), Color(0xFF532199)],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 1,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 8,
                        ),
                        child: Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Kecerdasan Buatan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 0),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Ini adalah deskripsi kecerdasan buatan',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            // Edit Logic
                          },
                          child: const Icon(
                            Icons
                                .edit,
                            color: Colors.white70,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Placeholder for calendar
          Container(
            height: 280,
            color: Colors.grey.shade200,
            alignment: Alignment.center,
            child: Text('Calendar Placeholder'),
          ),

          // My Task Header
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Task',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4D107F),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: const Color(0xFF7E1AD1),
                    child: const Icon(Icons.add, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Divider(color: Colors.grey, thickness: 1, height: 1),
          ),

          // Scrollable Task List
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.only(
                top: 15,
              ), 
              itemCount: dummyTasks.length,
              itemBuilder: (context, index) {
                final task = dummyTasks[index];
                final color = cardColors[index % cardColors.length];
                return Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 60,
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          task['time'] ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TaskCard(
                          title: task['title'] ?? '',
                          description: task['desc'] ?? '',
                          color: color,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}