import 'package:app/constants/colors.dart';
import 'package:app/db/focus_timer_db_helper.dart';
import 'package:app/models/focus_timer_model.dart';
import 'package:flutter/material.dart';
import 'package:app/components/focus_timer_card.dart';
import 'package:app/pages/add_focus_mode.dart';
import 'package:app/components/delete_confirmation_dialog.dart';
import 'package:app/pages/edit_focus_mode.dart';

class FocusModePage extends StatefulWidget {
  const FocusModePage({super.key});

  @override
  State<FocusModePage> createState() => _FocusModePageState();
}

class _FocusModePageState extends State<FocusModePage> {
  List<FocusTimer> focusTimers = [];
  List<FocusTimer> displayedTimers = [];

  void initState() {
    super.initState();
    initFocusTimer();
  }

  void initFocusTimer() async {
    focusTimers = await FocusTimerDbHelper.getFocusTimer(orderBy: 'id ASC');
    setState(() {
      displayedTimers = focusTimers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Color(0xFF7E1AD1),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Focus Mode',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                displayedTimers.isEmpty
                    ? Center(
                      child: Text(
                        'Focus mode is still empty. Add a focus mode to set your time.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600], fontSize: 18),
                      ),
                    )
                    : ListView.builder(
                      itemCount: displayedTimers.length,
                      itemBuilder: (context, index) {
                        final timer = displayedTimers[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Stack(
                            children: [
                              FocusModeCard(
                                title: timer.name,
                                focusTimeValue: timer.formattedFocusTimeValue,
                                breakTimeValue: timer.formattedBreakTimeValue,
                                sectionValue: timer.formattedSectionTimeValue,
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    if (value == 'edit') {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => EditFocusForm(
                                                timer: timer,
                                              ),
                                        ),
                                      );
                                      print('editttt cuyyyyy');
                                      if (result == true) {
                                        initFocusTimer();
                                      }
                                    } else if (value == 'delete') {
                                      final result =
                                          await deleteFocusTimerConfirmationDialog(
                                            context,
                                            timer,
                                          );
                                      print('delete cuyyyyy');
                                      if (result == true) {
                                        initFocusTimer();
                                      }
                                    }
                                  },
                                  itemBuilder:
                                      (context) => [
                                        const PopupMenuItem(
                                          value: 'edit',
                                          child: Text('Edit'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'delete',
                                          child: Text('Delete'),
                                        ),
                                      ],
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: const Color.fromARGB(255, 1, 1, 1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60.0, right: 20.0),
              child: FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FocusForm()),
                  );
                  if (result == true) {
                    initFocusTimer();
                  }
                },
                backgroundColor: Colors.deepPurple,
                shape: const CircleBorder(),
                child: const Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
