import 'package:flutter/material.dart';

class EditBukuView extends StatefulWidget {
  const EditBukuView({super.key});

  @override
  State<EditBukuView> createState() => _EditBukuViewState();
}

class _EditBukuViewState extends State<EditBukuView> {
  final _judulBukuController = TextEditingController();
  final _kategoryController = TextEditingController();

  final bool _validateJudul = false;
  final bool _validateKategory = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Data Buku')),

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Data Buku',
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
                    onPressed: () {},
                    child: Text("Update Details"),
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
                    onPressed: () {},
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
