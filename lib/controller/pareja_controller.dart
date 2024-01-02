import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:nuestra_historia/controller/auth_controller.dart';
import 'package:nuestra_historia/controller/mastersession_controller.dart';
import 'package:nuestra_historia/models/relacion_model.dart';
import 'package:nuestra_historia/screens/home/home_screen.dart';
import 'package:nuestra_historia/screens/widgets/dialog.dart';

class ParejaController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final mMasterSession = Get.find<MasterSessionController>();
  final authController = Get.find<AuthController>();

  Future<void> saveCodePareja(String code) async {
    showLoadingDialog();
    try {
      if (await verificarUserCodigo() == false) {
        var pareja = Relacion();
        pareja.codigo = code;
        pareja.user1Id = mMasterSession.currentUsuario.value.id;
        await addCodeParejaFirebase(pareja);
        hideLoadingDialog();
      } else {
        hideLoadingDialog();
        customDialogFailed('Error', 'Ya tienes un codigo pendiente');
      }
    } catch (error) {
      hideLoadingDialog();
      customDialogFailed('Error', 'Hubo un error: $error');
    }
  }

  Future<void> entrarRelacion(String code) async {
    showLoadingDialog();
    try {
      if (await verificarUserCodigo() == false) {
        final QuerySnapshot query = await firestore
            .collection('parejas')
            .where('codigo', isEqualTo: code)
            .where('estado', isEqualTo: true)
            .get();
        if (query.docs.isNotEmpty) {
          final DocumentSnapshot document = query.docs.first;
          String user1Id = document['user1Id'];

          if (document['user2Id'] == null || document['user2Id'].isEmpty) {
            await firestore
                .collection('parejas')
                .doc(document.id)
                .update({'user2Id': mMasterSession.currentUsuario.value.id});
            //user
            final pareja = await authController.getUsuario(user1Id);
            mMasterSession.currentUsuarioPareja.value = pareja!;
            mMasterSession.listenToUserChanges(pareja.id);
            await updateRelacionIDUsuario(
                mMasterSession.currentUsuario.value.id, document.id, pareja.id);
            await updateRelacionIDUsuario(pareja.id, document.id,
                mMasterSession.currentUsuario.value.id); //PAREJA
          }
          hideLoadingDialog();
          customDialogExito('Felicidad', 'Todo correcto', () {
            Get.to(() => const HomeScreen());
          });
        } else {
          hideLoadingDialog();
          customDialogFailed('Error', 'Codigo incorrecto');
        }
      } else {
        hideLoadingDialog();
        customDialogFailed(
            'Error', 'Ocurrio un problema al unirse a la relacion');
      }
    } catch (error) {
      hideLoadingDialog();
      customDialogFailed('Error', 'Hubo un error: $error');
    }
  }

  Future<void> addCodeParejaFirebase(Relacion relacion) async {
    try {
      final Map<String, dynamic> data = relacion.toMap();
      await firestore.collection('parejas').add(data);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateRelacionIDUsuario(
      String userId, String code, String parejaId) async {
    try {
      await firestore
          .collection('usuarios')
          .doc(userId)
          .update({'relacionId': code});
      await firestore
          .collection('usuarios')
          .doc(userId)
          .update({'parejaId': parejaId});
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> verificarUserCodigo() async {
    try {
      final QuerySnapshot query1 = await firestore
          .collection('parejas')
          .where('user1Id', isEqualTo: mMasterSession.currentUsuario.value.id)
          .where('estado', isEqualTo: true)
          .get();
      final QuerySnapshot query2 = await firestore
          .collection('parejas')
          .where('user2Id', isEqualTo: mMasterSession.currentUsuario.value.id)
          .where('estado', isEqualTo: true)
          .get();

      return query1.docs.isNotEmpty || query2.docs.isNotEmpty;
    } catch (error) {
      rethrow;
    }
  }
}
