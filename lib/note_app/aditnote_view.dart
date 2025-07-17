import 'package:flutter/material.dart';
import '../helper/db_helper.dart';
import '../model/model_buku.dart';

class EditnoteView extends StatefulWidget {
  final int id;
  final String judul;
  final String kategori;

  const EditnoteView({
    super.key,
    required this.id,
    required this.judul,
    required this.kategori,
  });

  @override
  State<EditnoteView> createState() => _EditnoteViewState();
}

class _EditnoteViewState extends State<EditnoteView> {
  late TextEditingController _judulBukuController;
  late TextEditingController _kategoriBukuController;

  bool _validateJudul = false;
  bool _validateKategori = false;

  @override
  void initState() {
    super.initState();
    _judulBukuController = TextEditingController(text: widget.judul);
    _kategoriBukuController = TextEditingController(text: widget.kategori);
  }

  @override
  void dispose() {
    _judulBukuController.dispose();
    _kategoriBukuController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    setState(() {
      _validateJudul = _judulBukuController.text.isEmpty;
      _validateKategori = _kategoriBukuController.text.isEmpty;
    });

    if (!_validateJudul && !_validateKategori) {
      final updatedBuku = ModelBuku(
        id: widget.id,
        judulbuku: _judulBukuController.text,
        kategory: _kategoriBukuController.text,
      );

      await DatabaseHelper.instance.updateBuku(updatedBuku);

      // Kembalikan data yang sudah diupdate ke halaman sebelumnya
      Navigator.pop(context, updatedBuku);
    }
  }



  void _clearFields() {
    _judulBukuController.clear();
    _kategoriBukuController.clear();
    setState(() {
      _validateJudul = false;
      _validateKategori = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Edit Notes',
            style: TextStyle(color: Colors.black, fontFamily: 'Abel', fontWeight: FontWeight.bold),),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              tooltip: 'Save',
              onPressed: _saveNote,
            ),
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _judulBukuController,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Title',
                      errorText: _validateJudul ? 'Title is required' : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 180,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _kategoriBukuController,
                      maxLines: 30,
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
