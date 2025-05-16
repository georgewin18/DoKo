import 'package:app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:app/models/task_model.dart';

final class Calendar extends StatefulWidget {
  const Calendar({
    super.key,
    required this.isHomepage,
    required this.onDateSelected,
    this.tasks = const [],
    this.selectedDate,
  });

  final bool isHomepage;
  final List<Task> tasks;
  final ValueChanged<String> onDateSelected;
  final DateTime? selectedDate;

  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  PageController pageController = PageController(initialPage: 12);
  int currentIndex = 12;
  DateTime _currentDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();

    final now = DateTime.now();
    final differeceInMonths = (_selectedDate.year - now.year) * 12 + (_selectedDate.month - now.month);
    currentIndex = 12 + differeceInMonths;
    _currentDate = DateTime(now.year, now.month + differeceInMonths);

    pageController = PageController(initialPage: currentIndex);
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
        width: widget.isHomepage ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width * 0.9,
        height: widget.isHomepage ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.width * 0.9,
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
                  child: Container(
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
                                          widget.onDateSelected(
                                            DateFormat(
                                              'yyyy-MM-dd',
                                            ).format(day),
                                          );
                                        });
                                      },

                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            width: width * 0.075,
                                            height: width * 0.075,
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
                                                      : Border.all(
                                                        color: transparent,
                                                        width: 2,
                                                      ),
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
                                          if (_hasTaskOnDate(day))
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

  bool _hasTaskOnDate(DateTime date) {
    return widget.tasks.any((task) {
      final taskDate = DateTime.parse(task.date);
      return taskDate.year == date.year &&
          taskDate.month == date.month &&
          taskDate.day == date.day;
    });
  }
}
