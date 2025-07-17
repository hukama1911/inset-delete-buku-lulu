import 'package:flutter/material.dart';

import '../helper/db_helper.dart';
import '../model/model_buku.dart';


class AddnoteView extends StatefulWidget {
  const AddnoteView({super.key});

  @override
  State<AddnoteView> createState() => _AddnoteViewState();
}

class _AddnoteViewState extends State<AddnoteView> {
  final _judulBukuController = TextEditingController();
  final _kategoriBukuController = TextEditingController();

  bool _validateJudul = false;
  bool _validateKategori = false;

  Future<void> _saveNote() async {
    setState(() {
      _validateJudul = _judulBukuController.text.isEmpty;
      _validateKategori = _kategoriBukuController.text.isEmpty;
    });

    if (!_validateJudul && !_validateKategori) {
      final newBuku = ModelBuku(
        judulbuku: _judulBukuController.text,
        kategory: _kategoriBukuController.text,
      );
      final result = await DatabaseHelper.instance.insertData(newBuku);
      Navigator.pop(context, true); // Return true to indicate success
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true, // Penting agar konten naik saat keyboard muncul
        appBar: AppBar(
          title: const Text('Add Notes',
            style: TextStyle(color: Colors.black, fontFamily: 'Abel', fontWeight: FontWeight.bold),),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              tooltip: 'Save',
              onPressed: _saveNote,
            ),
          ],
        ),
        body: SafeArea( // Tambahkan SafeArea
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _judulBukuController,
                  style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Title',
                    errorText: _validateJudul ? 'Title is required' : null,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 180,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _kategoriBukuController,
                    maxLines: 100,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Start writing',
                      errorText: _validateKategori ? 'Content is required' : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
                        );

            }
}
