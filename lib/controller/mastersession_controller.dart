import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:nuestra_historia/models/cita_model.dart';
import 'package:nuestra_historia/models/relacion_model.dart';
import 'package:nuestra_historia/models/usuario_model.dart';

class MasterSessionController extends GetxController {
  var currentUsuario = Usuario().obs;
  var currentRelacion = Relacion().obs;
  var currentUsuarioPareja = Usuario().obs;
  var currentUsuarioTemp = Usuario().obs;
  var currentCita = Cita().obs;
  var fmcToken = "".obs;

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

  void listenToUserChangesPareja(String userId) {
    FirebaseFirestore.instance
        .collection('usuarios')
        .doc(userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        data['id'] = userId;
        currentUsuarioPareja.value = Usuario.fromMap(data);
      }
    });
  }

  void listenToRelacionChanges(String relacionId) {
    FirebaseFirestore.instance
        .collection('parejas')
        .doc(relacionId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        data['id'] = relacionId;
        currentRelacion.value = Relacion.fromMap(data);
      }
    });
  }
}
