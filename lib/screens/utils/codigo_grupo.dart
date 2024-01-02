import 'dart:math';

String generarCodigo() {
  final random = Random();
  const String caracteres =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  const int longitudCodigo = 6;

  return String.fromCharCodes(Iterable.generate(
    longitudCodigo,
    (_) => caracteres.codeUnitAt(random.nextInt(caracteres.length)),
  ));
}
