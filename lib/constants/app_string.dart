import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_preferences.dart';

class AppString {
  final bool isEn;

  AppString(BuildContext context)
    : isEn =
          Provider.of<UserPreferences>(context, listen: false).language == 'en';

  //
  String get greeting => isEn ? 'Hello!' : 'Halo!';
  String get jargon =>
      isEn ? 'Manage your task with Doko' : 'Atur tugasmu dengan Doko';
  //
  String get name => isEn ? 'Name' : 'Nama';
  String get date => isEn ? 'Date' : 'Tanggal';
  //
  String get taskGroupTitle => isEn ? 'Task Group' : 'Grup Tugas';
  String get taskTitle => isEn ? 'Task Title' : 'Judul Tugas';
  String get taskListTitle => isEn ? 'Task List' : 'List Tugas';
  String get myTask => isEn ? "My Task" : "Tugas Saya";

  String get deadline => isEn ? "Deadline" : "Tenggat";
  String get addNotesHint => isEn ? "Add Notes..." : "Tambah Catatan...";
  String get addYourLinkHint =>
      isEn ? "Add your link here..." : "Tautkan link anda di sini...";
  String get cancel => isEn ? "Cancel" : "Batalkan";
  String get progress => isEn ? "Progress" : "Kemajuan";
  //
  String get editGroupTitle => isEn ? "Edit Info Group" : "Edit Info Grup";
  String get deleteGroupTitle => isEn ? "Delete Group" : "Hapus Grup";
  String get sortBy => isEn ? "Sort By" : "Urutkan berdasarkan";
  //
  String get emptyTaskNotifier =>
      isEn
          ? "You don't have any task for now!"
          : "Anda tidak punya tugas untuk saat ini!";
  String get emptyTitleNotifier =>
      isEn ? "Title can't be empty" : "Judul tak boleh kosong";
  String get taskAddedNotifier =>
      isEn ? "Task successfully added" : "Tugas berhasil ditambahkan";
  String get noTaskNotifier =>
      isEn ? "There is no task on" : "Tidak ada tugas pada";
  //
  String get groupTitleHint => isEn ? "Group Title" : "Judul Grup";
  String get descriptionHint => isEn ? "Description..." : "Deskripsi";
  String get saveTask => isEn ? "Save" : "Simpan";
  String get taskDeleted => isEn ? "Task deleted" : "Tugas terhapus";
  String get taskUpdated => isEn ? "Task updated" : "Tugas terupdate";
  String get save => isEn ? "Save" : "Simpan";
  //
  String get unknownGroup => isEn ? "Unknown Group" : "Grup tak dikenali";
  String get createGroup => isEn ? "Create New Group" : "Buat Grup Baru";
  String get noGroupNotifier =>
      isEn
          ? "You don't have any group, create one now!"
          : "Anda tidak punya grup, buatlah sekarang!";

  String get uniqueTitleNotifier =>
      isEn
          ? "Title must be unique!\nYou already have this group"
          : "Judul harus unik!\n Anda sudah mempunyai grup ini!";
  String get failedUpdatingTaskNotifier =>
      isEn ? "Failed updating task" : "Gagal memperbarui tugas";

  String get selectDeadlineNotifier =>
      isEn ? "Please select a deadline" : "Mohon pilih tenggat tugas";
}
