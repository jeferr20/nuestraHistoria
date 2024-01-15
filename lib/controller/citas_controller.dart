import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:nuestra_historia/controller/auth_controller.dart';
import 'package:nuestra_historia/controller/mastersession_controller.dart';
import 'package:nuestra_historia/models/cita_model.dart';
import 'package:nuestra_historia/models/datoRptaCita_model.dart';

class CitasController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  final mMasterSession = Get.find<MasterSessionController>();
  final authController = Get.find<AuthController>();

  Future<List<Cita>> getListadoCita() async {
    try {
      final querySnapshot = await firestore.collection('citas').get();

      List<Cita> citas = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return Cita.fromMap(data)..id = doc.id;
      }).toList();

      citas.sort((a, b) => a.categoria.compareTo(b.categoria));

      return citas;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> guardarDatosCita(
      DatosRptaCita rptaCita, List<String>? listadImagenesString) async {
    try {
      List<String> listaUrlImaFire = [];
      final DocumentReference parejasDocRef = firestore
          .collection('parejas')
          .doc(mMasterSession.currentRelacion.value.id);

      final DocumentSnapshot parejasDoc = await parejasDocRef.get();

      if (parejasDoc.exists) {
        List<String> citasRealizadas =
            List<String>.from(parejasDoc['citasRealizadas'] ?? []);

        citasRealizadas.add(rptaCita.citaID);
        if (listadImagenesString != null && listadImagenesString.isNotEmpty) {
          List<Map<String, dynamic>> uploadResults = await uploadImagenes(
              listadImagenesString, mMasterSession.currentCita.value.id);
          bool allSuccess = uploadResults.every((result) => result['success']);
          if (allSuccess) {
            List<String> imageUrls =
                uploadResults.map((result) => result['url'] as String).toList();
            listaUrlImaFire = imageUrls;
          } else {
            throw Exception('Error al subir una o más fotos');
          }
        }
        rptaCita.mediaUrl = listaUrlImaFire;
        await parejasDocRef.update({'citasRealizadas': citasRealizadas});
        final Map<String, dynamic> data = rptaCita.toMap();
        await firestore.collection('parejasRpta').add(data);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> actualizarDatosCita(DatosRptaCita rptaCita) async {
    try {
      await firestore.collection('parejasRpta').doc(rptaCita.id).update({
        'corazones': rptaCita.corazones,
        'userRpta': rptaCita.userRpta,
        'fecha': rptaCita.fecha
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<List<String>> getCitasRealizadas() async {
    try {
      final DocumentSnapshot parejasDoc = await firestore
          .collection('parejas')
          .doc(mMasterSession.currentRelacion.value.id)
          .get();

      if (parejasDoc.exists) {
        List<String> citasRealizadas =
            List<String>.from(parejasDoc['citasRealizadas'] ?? []);
        return citasRealizadas;
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<DatosRptaCita?> getDatosRptaCita() async {
    try {
      final rptaDocs = await firestore
          .collection('parejasRpta')
          .where('relacionId',
              isEqualTo: mMasterSession.currentRelacion.value.id)
          .where('citaID', isEqualTo: mMasterSession.currentCita.value.id)
          .get();
      if (rptaDocs.docs.isNotEmpty) {
        final rptaDoc = rptaDocs.docs.first;
        final Map<String, dynamic> data = rptaDoc.data();
        List<dynamic>? mediaUrlList = data['mediaUrl'];
        if (mediaUrlList != null) {
          List<String> mediaUrlStringList =
              mediaUrlList.map((dynamic item) => item.toString()).toList();
          data['mediaUrl'] = mediaUrlStringList;
        }
        data['id'] = rptaDoc.id;
        return DatosRptaCita.fromMap(data);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> uploadImagenes(
      List<String> imagePaths, String citaId) async {
    List<Map<String, dynamic>> results = [];

    try {
      for (String imagePath in imagePaths) {
        final String nombreArchivo = imagePath.split("/").last;
        final Reference ref = storage
            .ref()
            .child("imagenesCitas")
            .child(mMasterSession.currentRelacion.value.id)
            .child(nombreArchivo);
        final UploadTask uploadTask = ref.putFile(File(imagePath));

        final TaskSnapshot snapshot = await uploadTask;

        if (snapshot.state == TaskState.success) {
          final String urlImagen = await snapshot.ref.getDownloadURL();
          results.add({'success': true, 'url': urlImagen});
        } else {
          results.add({'success': false, 'url': ''});
        }
      }
    } catch (e) {
      results.add({'success': false, 'url': ''});
    }

    return results;
  }
}
