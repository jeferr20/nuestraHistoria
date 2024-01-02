class Usuario {
  String id;
  String correo;
  String nombres;
  String apellidos;
  String celular;
  String genero;
  int edad = 0;
  String fechaNacimiento;
  bool isVerified;
  String? urlPerfil;
  String? password;
  String? confirmPassword;
  String? relacionId;
  String? parejaId;

  Usuario(
      {this.id = "",
      this.correo = "",
      this.nombres = "",
      this.apellidos = "",
      this.celular = "",
      this.genero = "",
      this.edad = 0,
      this.fechaNacimiento = "",
      this.isVerified = false,
      this.urlPerfil,
      this.password,
      this.confirmPassword,
      this.relacionId,
      this.parejaId});

  Map<String, dynamic> toMap() {
    return {
      'correo': correo,
      'nombres': nombres,
      'apellidos': apellidos,
      'celular': celular,
      'genero': genero,
      'edad': edad,
      'fechaNacimiento': fechaNacimiento,
      'isVerified': isVerified,
      'urlPerfil': urlPerfil,
      'relacionId': relacionId,
      'parejaId': parejaId,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] ?? "",
      correo: json['correo'] ?? "",
      nombres: json['nombres'] ?? "",
      apellidos: json['apellidos'] ?? "",
      celular: json['celular'] ?? "",
      genero: json['genero'] ?? "",
      edad: json['edad'] ?? 0,
      fechaNacimiento: json['fechaNacimiento'] ?? "",
      isVerified: json['isVerified'] ?? false,
      urlPerfil: json['urlPerfil'] ?? "",
      relacionId: json['relacionId'] ?? "",
      parejaId: json['parejaId'] ?? "",
    );
  }
}
