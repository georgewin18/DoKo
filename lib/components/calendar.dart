import 'package:app/constants/colors.dart';
import 'package:app/constants/length.dart';
import 'package:app/constants/red_dates.dart';
import 'package:app/constants/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:app/models/task_model.dart';
import 'package:provider/provider.dart';

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
  Map<String, List<String>> redDates = {};
  Offset? _tapPosition;
  List<Color> colorPreference = [];
  bool _isInitialized = false;

  Future<void> fetchRedDates(int year, int month) async {
    final redDatesInstance = RedDates(context);
    final result = redDatesInstance.getRedDatesForMonth(year, month);
    setState(() {
      redDates = result;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();

    final now = DateTime.now();
    final differeceInMonths =
        (_selectedDate.year - now.year) * 12 +
        (_selectedDate.month - now.month);
    currentIndex = 12 + differeceInMonths;
    _currentDate = DateTime(now.year, now.month + differeceInMonths);

    pageController = PageController(initialPage: currentIndex);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      colorPreference =
          Provider.of<UserPreferences>(context, listen: false).colorPreference;
      fetchRedDates(_currentDate.year, _currentDate.month);
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        width: Length(input: "calendar", context: context).width(),
        height: Length(input: "calendar", context: context).height(),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;
            double height = constraints.maxHeight;
            double dayFontSize = width * 0.045;
            double dateFontSize = width * 0.035;
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
                          fetchRedDates(_currentDate.year, _currentDate.month);
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
                                    top: width * 0.035,
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
                                      onTapDown: (TapDownDetails details) {
                                        _tapPosition = details.globalPosition;
                                      },
                                      onTap: () {
                                        if (_isRedDate(day) &&
                                            _tapPosition != null) {
                                          final messages =
                                              redDates[DateFormat(
                                                'yyyy-MM-dd',
                                              ).format(day)]!;
                                          _showRedDatePopup(
                                            context,
                                            messages,
                                            _tapPosition!,
                                          );
                                        }

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
                                            margin: EdgeInsets.all(
                                              width * 0.03,
                                            ),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  isSelected
                                                      ? colorPreference[2]
                                                      : Colors.transparent,
                                              border:
                                                  !isSelected && isToday
                                                      ? Border.all(
                                                        color:
                                                            colorPreference[2],
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
                                                  fontSize: dateFontSize,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      isSelected
                                                          ? white
                                                          : isToday
                                                          ? colorPreference[2]
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
                                          if (_isRedDate(day))
                                            Positioned(
                                              top: width * 0.02,
                                              right: width * 0.025,
                                              child: Container(
                                                width: width * 0.021,
                                                height: width * 0.021,
                                                decoration: BoxDecoration(
                                                  color: danger,
                                                  shape: BoxShape.circle,
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
          color: colorPreference[2],
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
        iconSize: Length(context: context, input: "box").width() * 0.075,
        color: widget.isHomepage ? white : black,
        onPressed: onPressed,
      ),
    );
  }

  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isRedDate(DateTime date) {
    final key = DateFormat('yyyy-MM-dd').format(date);
    return redDates.containsKey(key);
  }

  void _showRedDatePopup(
    BuildContext context,
    List<String> messages,
    Offset tapPosition,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final overlay =
          Overlay.of(context).context.findRenderObject() as RenderBox;
      final screenSize = overlay.size;

      const double popupMaxWidth = 200;
      const double popupMaxHeight = 200;
      const double padding = 8;

      double left = tapPosition.dx;
      double top = tapPosition.dy;

      if (left + popupMaxWidth + padding > screenSize.width) {
        left = screenSize.width - popupMaxWidth - padding;
      } else if (left < padding) {
        left = padding;
      }

      if (top + popupMaxHeight + padding > screenSize.height) {
        top = screenSize.height - popupMaxHeight - padding;
      } else if (top < padding) {
        top = padding;
      }

      final entry = OverlayEntry(
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                Positioned(
                  left: left,
                  top: top,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: popupMaxWidth,
                      maxHeight: popupMaxHeight,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: white,
                        boxShadow: [
                          BoxShadow(
                            color: gray1,
                            blurRadius: 3,
                            offset: Offset(2, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              messages.map((msg) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        margin: const EdgeInsets.only(
                                          top: 6,
                                          right: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: danger,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          msg,
                                          softWrap: true,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );

      Overlay.of(context).insert(entry);

      Future.delayed(const Duration(milliseconds: 1200), () {
        entry.remove();
      });
    });
  }
}
