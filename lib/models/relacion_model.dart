class Relacion {
  String id;
  String user1Id;
  String user2Id;
  String codigo;
  String aniversario;
  bool estado;
  List<String>? citasRealizadas;

  Relacion({
    this.id = "",
    this.user1Id = "",
    this.user2Id = "",
    this.codigo = "",
    this.aniversario = "",
    this.estado = true,
    this.citasRealizadas,
  });

  Map<String, dynamic> toMap() {
    return {
      'user1Id': user1Id,
      'user2Id': user2Id,
      'codigo': codigo,
      'estado': estado,
      'aniversario': aniversario,
      'citasRealizadas': citasRealizadas,
    };
  }

  factory Relacion.fromMap(Map<String, dynamic> json) {
    return Relacion(
      id: json['id'] ?? "",
      aniversario: json['aniversario'] ?? "",
      estado: json['estado'] ?? false,
      codigo: json['codigo'] ?? "",
      user2Id: json['user2Id'] ?? "",
      user1Id: json['user1Id'] ?? "",
      citasRealizadas:
          (json['citasRealizadas'] as List<dynamic>?)?.cast<String>(),
    );
  }
}
