class DatosRptaCita {
  String id;
  String citaID;
  String relacionId;
  String? user1ID;
  String? user2ID;
  String userRpta;
  int corazones;
  int estrellas;
  String fecha;
  List<String>? mediaUrl;

  DatosRptaCita({
    this.id = "",
    required this.citaID,
    this.user1ID,
    required this.relacionId,
    required this.userRpta,
    required this.corazones,
    required this.estrellas,
    required this.fecha,
    this.user2ID,
    this.mediaUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'citaID': citaID,
      'relacionId': relacionId,
      'user1ID': user1ID,
      'user2ID': user2ID,
      'userRpta': userRpta,
      'mediaUrl': mediaUrl,
      'corazones': corazones,
      'estrellas': estrellas,
      'fecha': fecha,
    };
  }

  factory DatosRptaCita.fromMap(Map<String, dynamic> json) {
    return DatosRptaCita(
      id: json['id'] ?? "",
      relacionId: json['relacionId'] ?? "",
      citaID: json['citaID'] ?? "",
      user1ID: json['user1ID'] ?? "",
      user2ID: json['user2ID'] ?? "",
      userRpta: json['userRpta'] ?? "",
      mediaUrl: json['mediaUrl'] ?? [],
      corazones: json['corazones'] ?? 0,
      fecha: json['fecha'] ?? 0,
      estrellas: json['estrellas'] ?? 0,
    );
  }
}
