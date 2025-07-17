import 'package:flutter/material.dart';

import '../helper/db_helper.dart';
import '../model/model_buku.dart';
import 'addnote_view.dart';
import 'aditnote_view.dart';


class NoteHomePage extends StatefulWidget {
  const NoteHomePage({super.key});

  @override
  State<NoteHomePage> createState() => _NoteHomePageState();
}

class _NoteHomePageState extends State<NoteHomePage> {
  List<ModelBuku> _buku = [];
  bool _isLoading = false;
  TextEditingController _searchController = TextEditingController();
  List<ModelBuku> _filteredBuku = [];


  @override
  void initState() {
    super.initState();
    _fetchDataBuku();
  }

  Future<void> _fetchDataBuku() async {
    setState(() => _isLoading = true);
    final bukuMaps = await DatabaseHelper.instance.quaryAllBuku();

    // Ubah ke list model
    final allBuku = bukuMaps.map((e) => ModelBuku.fromMap(e)).toList();

    setState(() {
      _buku = allBuku;
      _filteredBuku = allBuku;
      _isLoading = false;
    });
  }

  // Navigate to add screen and wait for result to add new book immediately
  Future<void> _navigateToAdd() async {
    final bool? added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const AddnoteView()),
    );
    if (added == true) {
      _fetchDataBuku();
    }
  }

  // Navigate to edit screen and wait for result to refresh list if edited
  Future<void> _navigateToEdit(ModelBuku buku) async {
    final ModelBuku? updatedBuku = await Navigator.push<ModelBuku>(
      context,
      MaterialPageRoute(
        builder: (context) => EditnoteView(
          id: buku.id!,
          judul: buku.judulbuku,
          kategori: buku.kategory,
        ),
      ),
    );

    if (updatedBuku != null) {
      // Cari index buku yang diupdate di list lokal
      final index = _buku.indexWhere((element) => element.id == updatedBuku.id);
      if (index != -1) {
        setState(() {
          _buku[index] = updatedBuku;  // Update langsung data lokal
        });
      }
    }
  }

  void _searchBuku(String query) {
    final hasil = _buku.where((b) =>
    b.judulbuku.toLowerCase().contains(query.toLowerCase()) ||
        b.kategory.toLowerCase().contains(query.toLowerCase())
    ).toList();
    setState(() {
      _filteredBuku = hasil;
    });
  }


  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<bool?> _deleteFormDialog(BuildContext context, int bukuId) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Are you sure you want to delete?',
            style: TextStyle(color: Colors.teal, fontSize: 20),
          ),
          content: const Text('This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await DatabaseHelper.instance.deleteBuku(bukuId);
                Navigator.pop(context, true); // Confirm deletion
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    return confirm; // hanya kembalikan hasil dialog true/false
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF15353F);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          centerTitle: false,
          titleSpacing: 16,
          title: const Text(
            'Notes',
            style: TextStyle(color: Colors.white, fontFamily: 'Abel', fontWeight: FontWeight.w600),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  'https://th.bing.com/th/id/OIP.t_KO_nRnFO9pAYrCrTjAFAHaHa?w=195&h=195&c=7&r=0&o=5&dpr=1.3&pid=1.7',
                ),
              ),
            ),
          ],
        ),

        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                onChanged: _searchBuku,
                decoration: InputDecoration(
                    hintText: 'Search notes...',
                    prefixIcon: Icon(Icons.search, color: Color(0xFF36415D)),
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30), // Bikin bulat
                      borderSide: BorderSide(
                        color: Color(0xFF36415D),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Color(0xFF36415D),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: Color(0xFF36415D),
                          width: 2,
                        ),
                        ),
                    ),
              ),

              const SizedBox(height: 16),

              // Grid
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredBuku.isEmpty
                    ? const Center(
                  child: Text(
                    'No matching notes.',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                )
                    : GridView.builder(
                  itemCount: _filteredBuku.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 4 / 4,
                  ),
                  itemBuilder: (context, index) {
                    final buku = _filteredBuku[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => _navigateToEdit(buku),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                buku.judulbuku,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF36415D),
                                ),
                              ),
                              Text(
                                buku.kategory,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                  onPressed: () async {
                                    final confirm = await _deleteFormDialog(context, buku.id!);
                                    if (confirm == true) {
                                      _fetchDataBuku();
                                      _showSuccessSnackbar('Note deleted successfully');
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

    floatingActionButton: FloatingActionButton(
    onPressed: _navigateToAdd,
    backgroundColor: primaryColor,
    shape: const CircleBorder(), // memastikan bentuk bulat
    child: const Icon(Icons.add, color: Colors.white),
    tooltip:'AddNote',
    ),
    );

  }
}