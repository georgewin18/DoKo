// contoh penggunaan calendar, di main harus di inisialisasi terlebih dahulu
// guna mengetahui lokasi waktu yang digunakan, agar datanya sesuai dengan real time

import 'package:doko/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

// ini bisa nanti di comment
class Task {
  String title;
  DateTime date; // tanggal
  TimeOfDay? startTime; // Start time opsional buat event
  TimeOfDay? endTime; // End time opsional buat event
  DateTime? endDate; // End date untuk tenggat
  bool isEvent; // true = event, false = task,
  // TaskPriority priority;
  // TaskStatus status; //isinya warna jadi nanti ada pengecekannya
  bool
  isCompleted; // warna hijau dan nanti akan ada pembatas untuk tugas yang sudah selesai.

  Task({
    required this.title,
    required this.date,
    this.startTime,
    this.endTime,
    this.endDate,
    required this.isEvent,
    // this.priority = TaskPriority.normal,
    // this.status = TaskStatus.notStarted,
    this.isCompleted = false,
  });

  // TaskStatus calculateStatus(DateTime now) {
  //   if (isEvent) return TaskStatus.event;
  //   if (isCompleted) return TaskStatus.completed;
  //   if (priority == TaskPriority.priority) return TaskStatus.priority;

  //   final taskDateTime = DateTime(
  //     date.year,
  //     date.month,
  //     date.day,
  //     endTime?.hour ?? 23,
  //     endTime?.minute ?? 59,
  //   );

  //   if (now.isAfter(taskDateTime)) return TaskStatus.overdue;

  //   final isSameDay =
  //       now.year == date.year && now.month == date.month && now.day == date.day;

  //   if (isSameDay) return TaskStatus.dueToday;

  //   return TaskStatus.notStarted;
  // }
  // Color getStatusColor() {
  //   switch (status) {
  //     case TaskStatus.overdue:
  //       return statusColor[0];
  //     case TaskStatus.ongoing:
  //       return statusColor[1];
  //     case TaskStatus.notStarted:
  //       return statusColor[2];
  //     case TaskStatus.dueToday:
  //       return statusColor[3];
  //     case TaskStatus.completed:
  //       return statusColor[4];
  //     case TaskStatus.event:
  //       return statusColor[5];
  //     case TaskStatus.priority:
  //       return statusColor[6];
  //   }
  // }

  // // Update status based on current time
  // void updateStatus() {
  //   if (!isEvent) {
  //     status = calculateStatus(DateTime.now());
  //   }
  // }
}

final class Calendar extends StatefulWidget {
  const Calendar({required this.isHomepage, super.key});

  final bool isHomepage;

  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  PageController pageController = PageController(initialPage: 12);
  int currentIndex = 12;
  DateTime _currentDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  List<Task> _events = [];

  @override
  void initState() {
    super.initState();
    _dummy(); // tolong dihilangkan nanti
  }

  void _dummy() {
    _events = [
      // Task(
      //   title: 'Meeting Project',
      //   date: DateTime(2025, 4, 28),
      //   endTime: TimeOfDay(hour: 16, minute: 30),
      //   isEvent: false,
      //   // priority: TaskPriority.priority,
      //   // status: TaskStatus.priority,
      // ),
      // Task(
      //   title: 'Liburan ke Bali',
      //   date: DateTime(2025, 4, 21),
      //   startTime: TimeOfDay(hour: 9, minute: 0),
      //   endTime: TimeOfDay(hour: 18, minute: 0),
      //   endDate: DateTime(2025, 4, 28),
      //   isEvent: true,
      //   status: TaskStatus.event,
      // ),
      Task(
        title: 'Deadline Project',
        date: DateTime(2025, 5, 01),
        endTime: TimeOfDay(hour: 17, minute: 0),
        isEvent: false,
        // status: TaskStatus.dueToday,
      ),
      // Task(
      //   title: 'Late Task',
      //   date: DateTime(2025, 4, 20),
      //   endTime: TimeOfDay(hour: 23, minute: 59),
      //   isEvent: false,
      //   status: TaskStatus.overdue,
      // ),
    ];

    // for (var event in _events) {
    //   event.updateStatus();
    // }
  }

  List<DateTime> _generateCalendarDays(DateTime date) {
    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    final firstDayWeekday = firstDayOfMonth.weekday;

    final daysBefore = (firstDayWeekday + 6) % 7;
    final firstDisplayDay = firstDayOfMonth.subtract(
      Duration(days: daysBefore),
    );
    final totalDisplayDays = 42;

    return List.generate(
      totalDisplayDays,
      (index) => firstDisplayDay.add(Duration(days: index)),
    );
  }

  List<String> _getWeekdayNames(String locale) {
    final symbols = dateTimeSymbolMap()[locale];
    List<String> weekdayNames = symbols.NARROWWEEKDAYS;

    return [
      weekdayNames[1],
      weekdayNames[2],
      weekdayNames[3],
      weekdayNames[4],
      weekdayNames[5],
      weekdayNames[6],
      weekdayNames[0],
    ];
  }

  Widget _navButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isHomepage ? white.withAlpha(51) : white,
        shape: BoxShape.circle,
        boxShadow: [
          if (!widget.isHomepage)
            BoxShadow(
              color: gray3.withAlpha(51),
              offset: Offset(0, 4),
              blurRadius: 4,
            ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon),
        color: widget.isHomepage ? white : black,
        onPressed: onPressed,
      ),
    );
  }

  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        width: 500,
        height: 570,
        decoration: BoxDecoration(
          // color: themeColors[6],
          borderRadius: BorderRadius.circular(10),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;
            double height = constraints.maxHeight;
            double dayFontSize = width * 0.045;
            double monthFontSize = width * 0.07;
            double yearFontSize = width * 0.04;

            final currentDate = DateTime(
              DateTime.now().year,
              DateTime.now().month + (currentIndex - 12),
            );
            final month = DateFormat('MMMM', 'en_ISO').format(currentDate);
            final year = DateFormat('yyyy', 'en_ISO').format(currentDate);

            return Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                  child: Row(
                    children: [
                      _navButton(Icons.arrow_back_ios_new, () {
                        if (currentIndex > 0) {
                          pageController.previousPage(
                            duration: Duration(milliseconds: 600),
                            curve: Curves.easeInOut,
                          );
                        }
                      }),
                      Expanded(
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                month,
                                style: TextStyle(
                                  fontSize: monthFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: widget.isHomepage ? white : black,
                                ),
                              ),
                              Text(
                                year,
                                style: TextStyle(
                                  fontSize: yearFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: widget.isHomepage ? white : black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _navButton(Icons.arrow_forward_ios, () {
                        pageController.nextPage(
                          duration: Duration(milliseconds: 600),
                          curve: Curves.easeInOut,
                        );
                      }),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.03),
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                        _currentDate = DateTime(
                          DateTime.now().year,
                          DateTime.now().month + (index - 12),
                        );
                        _selectedDate = DateTime.now();
                      });
                    },
                    itemBuilder: (context, index) {
                      final currentDate = DateTime(
                        DateTime.now().year,
                        DateTime.now().month + (index - 12),
                      );
                      final calendarDays = _generateCalendarDays(currentDate);
                      final days = _getWeekdayNames('en');

                      return Container(
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: gray3.withAlpha(51),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            GridView.count(
                              padding: EdgeInsets.only(
                                left: width * 0.015,
                                right: width * 0.015,
                                top: width * 0.03,
                              ),
                              crossAxisCount: 7,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              childAspectRatio: 2.5,
                              children:
                                  days
                                      .map(
                                        (day) => Center(
                                          child: Text(
                                            day,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: dayFontSize,
                                              color: gray2,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                            Expanded(
                              child: GridView.builder(
                                padding: EdgeInsets.only(
                                  left: width * 0.015,
                                  top: width * 0.015,
                                  right: width * 0.015,
                                ),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 7,
                                      crossAxisSpacing: 0,
                                      mainAxisSpacing: 0,
                                    ),
                                itemCount: calendarDays.length,
                                itemBuilder: (context, index) {
                                  final day = calendarDays[index];
                                  final isCurrentMonth =
                                      day.month == _currentDate.month;
                                  DateTime today = DateTime.now();
                                  DateTime normalizedToday = DateTime(
                                    today.year,
                                    today.month,
                                    today.day,
                                  );
                                  bool isToday = isSameDate(
                                    day,
                                    DateTime.now(),
                                  );
                                  bool isSelected = isSameDate(
                                    day,
                                    _selectedDate,
                                  );

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedDate = day;
                                      });
                                      print(_showTasksOnDate(day));
                                    },

                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          width: width * 0.07,
                                          height: width * 0.07,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                isSelected
                                                    ? themeColors[6]
                                                    : Colors.transparent,
                                            border:
                                                !isSelected && isToday
                                                    ? Border.all(
                                                      color: themeColors[6],
                                                      width: 2,
                                                    )
                                                    : null,
                                          ),
                                          child: MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: Text(
                                              '${day.day}',
                                              style: TextStyle(
                                                fontSize: dayFontSize,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    isSelected
                                                        ? Colors.white
                                                        : isToday
                                                        ? themeColors[6]
                                                        : isCurrentMonth
                                                        ? (day.compareTo(
                                                                  normalizedToday,
                                                                ) <
                                                                0
                                                            ? gray3.withAlpha(
                                                              51,
                                                            )
                                                            : black)
                                                        : gray3.withAlpha(35),
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (_getTasksOnDate(day).isNotEmpty)
                                          Positioned(
                                            bottom: width * 0.01,
                                            child: _buildTaskIndicators(
                                              day,
                                              width,
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
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTaskIndicators(DateTime day, double width) {
    List<Widget> indicators = [];
    indicators.add(
      Container(
        width: width * 0.07,
        height: width * 0.01,
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: themeColors[6],
          // shape: BoxShape.circle,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: indicators,
    );
  }

  String _showTasksOnDate(DateTime date) {
    String dateConverted = DateFormat('dd-MM-yyy').format(date);
    return dateConverted;
  }

  List<Task> _getTasksOnDate(DateTime date) {
    return _events
        .where(
          (task) =>
              !task.isEvent &&
              task.date.year == date.year &&
              task.date.month == date.month &&
              task.date.day == date.day,
        )
        .toList();
  }
}
