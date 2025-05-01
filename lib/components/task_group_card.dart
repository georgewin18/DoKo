import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TaskGroupCard extends StatelessWidget {
  const TaskGroupCard({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 360,
        height: 104,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 10,
              offset: Offset(0, 2),
            )
          ]
        ),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(top: 4, left: 16),
              child: CircularPercentIndicator(
                radius: 30.0,
                lineWidth: 12.0,
                percent: 0.7,
                animation: true,
                animationDuration: 1200,
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.deepPurple,
              ),
            ),

            Container(
              padding: EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    width: 260,
                    height: 24,
                    child: Text(
                      "Group Title",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7E1AD1),
                      ),
                    )
                  ),

                  SizedBox(
                    width: 260,
                    height: 40,
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor...",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 8,
                            color: Colors.red,
                          ),

                          SizedBox(
                            width: 4,
                          ),

                          Text(
                            "5 Not Started",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),

                      SizedBox(
                        width: 12,
                      ),

                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 8,
                            color: Colors.yellow,
                          ),

                          SizedBox(
                            width: 4,
                          ),

                          Text(
                            "3 On-going",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),

                      SizedBox(
                        width: 12,
                      ),

                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 8,
                            color: Colors.green,
                          ),

                          SizedBox(
                            width: 4,
                          ),

                          Text(
                            "2 Completed",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}