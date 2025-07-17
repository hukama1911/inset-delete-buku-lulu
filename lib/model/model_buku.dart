class ModelBuku {
  final int? id;
  final String judulbuku;
  final String kategory;

  ModelBuku({this.id, required this.judulbuku, required this.kategory,});

  //method untuk insert data kedalam map
  Map<String, dynamic> toMap() {
    return {'id': id, 'judulbuku': judulbuku, 'kategory': kategory};
  }

  //get data
  factory ModelBuku.fromMap(Map<String, dynamic> map) {
    return ModelBuku(
      id: map['id'],
      judulbuku: map['judulbuku'],
      kategory: map['kategory'],
    );
  }
}
