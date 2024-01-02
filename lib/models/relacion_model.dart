class Relacion {
  String id;
  String user1Id;
  String user2Id;
  String codigo;
  bool estado;

  Relacion({
    this.id = "",
    this.user1Id = "",
    this.user2Id = "",
    this.codigo = "",
    this.estado = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'user1Id': user1Id,
      'user2Id': user2Id,
      'codigo': codigo,
      'estado': estado,
    };
  }
}
