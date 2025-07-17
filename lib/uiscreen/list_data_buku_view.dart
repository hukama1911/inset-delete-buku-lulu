import 'package:flutter/material.dart';
import 'package:sq_lite_project/helper/db_helper.dart';
import 'package:sq_lite_project/model/model_buku.dart';
import 'package:sq_lite_project/uiscreen/add_buku_view.dart';
import 'package:sq_lite_project/uiscreen/edit_buku_view.dart';

class ListDataBukuView extends StatefulWidget {
  const ListDataBukuView({super.key});

  @override
  State<ListDataBukuView> createState() => _ListDataBukuViewState();
}

class _ListDataBukuViewState extends State<ListDataBukuView> {
  List<ModelBuku> _buku = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    DatabaseHelper.instance.dummyBuku().then((_) {
      _fethDataBuku();
    });
    // _fethDataBuku();
  }

  Future<void> _fethDataBuku() async {
    setState(() {
      _isLoading = true;
    });
    final bukuMaps = await DatabaseHelper.instance.quaryAllBuku();
    setState(() {
      _buku = bukuMaps.map((bukuMaps) => ModelBuku.fromMap(bukuMaps)).toList();
      _isLoading = false;
    });
  }

  _showSuccessSnacBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  _deleteFormDialog(BuildContext contex, bukuId) {
    return showDialog(
      context: contex,
      builder: (param) {
        return AlertDialog(
          title: Text(
            'Are you sure to Delete?,',
            style: TextStyle(color: Colors.teal, fontSize: 20),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                var result = await DatabaseHelper.instance.deleteBuku(bukuId);
                if (result != null) {
                  Navigator.pop(context);
                  _fethDataBuku();
                  _showSuccessSnacBar('Data Buku Berhasil Dihapus');
                }
              }, child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Data Buku'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _fethDataBuku();
            },
          ),
        ],
      ),

      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _buku.length,
                itemBuilder: (context, index) {
                  final buku = _buku[index];
                  return ListTile(
                    title: Text(buku.judulbuku),
                    subtitle: Text(buku.kategory),

                    //button delete
                    onLongPress: () {
                      _deleteFormDialog(context, _buku[index].id);
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          (context),
                          MaterialPageRoute(
                            builder: (context) => EditBukuView(),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBukuView()),
          );
          _fethDataBuku();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}