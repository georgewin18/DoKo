import 'package:doko/components/task_group_card.dart';
import 'package:flutter/material.dart';

class TaskGroupPage extends StatelessWidget {
  const TaskGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 184,
            padding: EdgeInsets.symmetric(horizontal: 28),
            decoration: BoxDecoration(
              color: Color(0xFF7E1AD1),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                ),

                Center(
                  child: Text(
                    "Your Group",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 12),
                  height: 36,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      filled: true,
                      fillColor: Color(0xFFD9D9D9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none
                      )
                    ),
                  )
                ),

                Container(
                  margin: EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 2
                        ),
                        child: Text(
                          "Sort by:",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12
                          ),
                        ),
                      ),

                      SizedBox(
                        width: 12
                      ),

                      Container(
                        width: 60,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Color(0xFFBF8DE8),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Center(
                          child: Text(
                            "Name",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                          width: 12
                      ),

                      Container(
                        width: 60,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Color(0xFF7E1AD1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Color(0xFFBF8DE8),
                            width: 1
                          )
                        ),
                        child: Center(
                          child: Text(
                            "Date",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                )
              ]
            ),
          ),

          SizedBox(
            height: 16,
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFF7E1AD1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        size: 28,
                        color: Colors.white,
                      ),

                      SizedBox(
                        width: 16,
                      ),

                      Text(
                        "Create New Group",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(
                  height: 16,
                ),

                SizedBox(
                  height: 584,
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: 6,
                    itemBuilder: (context, index) => TaskGroupCard(),
                    separatorBuilder: (context, index) => SizedBox(height: 16)
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }
}