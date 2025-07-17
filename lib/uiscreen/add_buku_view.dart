import 'package:flutter/material.dart';
import 'package:sq_lite_project/helper/db_helper.dart';
import 'package:sq_lite_project/model/model_buku.dart';

class AddBukuView extends StatefulWidget {
  const AddBukuView({super.key});

  @override
  State<AddBukuView> createState() => _AddBukuViewState();
}

class _AddBukuViewState extends State<AddBukuView> {
  final _judulBukuController = TextEditingController();
  final _kategoryController = TextEditingController();

  bool _validateJudul = false;
  bool _validateKategory = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Data Buku')),

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Data Buku',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _judulBukuController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Judul Buku',
                  errorText:
                      _validateJudul ? 'Judul Buku tidak boleh kosong' : null,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _kategoryController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Kategory',
                  errorText:
                      _validateKategory ? 'Kategory tidak boleh kosong' : null,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.teal,
                      textStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        _judulBukuController.text.isEmpty
                            ? _validateJudul = true
                            : _validateJudul = false;
                        _kategoryController.text.isEmpty
                            ? _validateKategory = true
                            : _validateKategory = false;
                      });

                      if (_validateJudul == false &&
                          _validateKategory == false) {
                        //kita save data ke database
                        var buku = ModelBuku(
                          judulbuku: _judulBukuController.text,
                          kategory: _kategoryController.text,
                        );
                        var result = await DatabaseHelper.instance.insertData(
                          buku,
                        );
                        //pindah page setelah berhasil insert
                        Navigator.pop(context, result);
                      }
                    },
                    child: Text("Save Details"),
                  ),
                  SizedBox(width: 10),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      textStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      //clear text field
                      _judulBukuController.text = '';
                      _kategoryController.text = '';
                    },
                    child: Text("Clear Details"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
