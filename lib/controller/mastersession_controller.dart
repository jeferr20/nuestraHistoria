import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:nuestra_historia/models/usuario_model.dart';

class MasterSessionController extends GetxController {
  var currentUsuario = Usuario().obs;
  var currentUsuarioPareja = Usuario().obs;
  var currentUsuarioTemp = Usuario().obs;

  void listenToUserChanges(String userId) {
    FirebaseFirestore.instance
        .collection('usuarios')
        .doc(userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        data['id'] = userId;
        currentUsuario.value = Usuario.fromMap(data);
      }
    });
  }
}
