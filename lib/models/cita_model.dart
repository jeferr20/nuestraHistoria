class Cita {
  String id;
  String cita;
  String categoria;

  Cita({
    this.id = "",
    this.cita = "",
    this.categoria = "",
  });

  Map<String, dynamic> toMap() {
    return {
      'cita': cita,
      'categoria': categoria,
    };
  }

  factory Cita.fromMap(Map<String, dynamic> json) {
    return Cita(
      id: json['id'] ?? "",
      cita: json['cita'] ?? "",
      categoria: json['categoria'] ?? "",
    );
  }
}

class CategoriaCitas {
  CategoriaCitas(
      {required this.categoria, this.isExpanded = false, required this.citas});
  String categoria;
  bool isExpanded;
  List<Cita> citas;
}
