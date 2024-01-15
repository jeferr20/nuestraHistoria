import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:nuestra_historia/controller/mastersession_controller.dart';
import 'package:nuestra_historia/models/relacion_model.dart';
import 'package:nuestra_historia/models/usuario_model.dart';
import 'package:nuestra_historia/screens/home/main_screen.dart';
import 'package:nuestra_historia/screens/login/login_screen.dart';
import 'package:nuestra_historia/screens/widgets/dialog.dart';

class AuthController extends GetxController {
  static AuthController instace = Get.find();
  late Rx<User?> user;
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  final mMasterSession = Get.put(MasterSessionController());

  @override
  void onReady() {
    super.onReady();
    user = Rx<User?>(auth.currentUser);
    user.bindStream(auth.userChanges());
    ever(user, _setInitialScreen);
  }

  _setInitialScreen(User? user) async {
    if (user == null) {
      Get.offAll(() => const LoginScreen());
    } else {
      final usuario = await getUsuario(auth.currentUser!.uid);

      Usuario? pareja;
      Relacion? relacion;
      if (usuario!.parejaId != "") pareja = await getUsuario(usuario.parejaId!);
      if (usuario.relacionId != "") {
        relacion = await getRelacion(usuario.relacionId!);
      }
      mMasterSession.currentUsuario.value = usuario;

      mMasterSession.listenToUserChanges(
        user.uid,
      );
      await registrarDevice();
      if (pareja != null && relacion != null) {
        mMasterSession.currentUsuarioPareja.value = pareja;
        mMasterSession.listenToUserChangesPareja(
          pareja.id,
        );
        mMasterSession.currentRelacion.value = relacion;
        mMasterSession.listenToRelacionChanges(
          relacion.id,
        );
      }

      if (usuario.id != "") {
        bool veri = user.emailVerified;
        if (veri) {
          if (!usuario.isVerified) {
            await actualizarUsuarioVerificado(usuario);
          }
          Get.offAll(() => const MainScreen());
        } else {
          customDialogEmail(
            'Error',
            'Verifique su correo',
            () async {
              await user.reload();
              await Future.delayed(const Duration(milliseconds: 10));
              await _setInitialScreen(auth.currentUser);
            },
            () {
              Get.back();
            },
          );
        }
      }
    }
  }

  Future<void> loginUsuario(String email, String password) async {
    showLoadingDialog();
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      hideLoadingDialog();
    } catch (error) {
      hideLoadingDialog();
      customDialogFailed('Error', 'Hubo un error al iniciar sesion: $error',
          () => {Get.back()});
    }
  }

  Future<void> registrarUsuario(Usuario user) async {
    showLoadingDialog();
    try {
      await registrarUsuarioFirebase(user);
      String uid = auth.currentUser!.uid;
      await addDatosUsuario(user, uid);
      await sendEmailVerif();
    } catch (error) {
      hideLoadingDialog();
      customDialogFailed('Error', 'Hubo un error al crear el usuario: $error',
          () => {Get.back()});
    }
  }

  Future<void> actualizarDatosUsuario(Usuario user, String? urlImagen) async {
    try {
      String imageUrl = "";
      if (mMasterSession.currentUsuario.value.urlPerfil != null &&
          mMasterSession.currentUsuario.value.urlPerfil!.isNotEmpty) {
        await deleteFileFromStorage(
            mMasterSession.currentUsuario.value.urlPerfil!);
      }
      if (urlImagen != null && urlImagen.isNotEmpty) {
        Map<String, dynamic> uploadResults = await uploadImagen(urlImagen);
        imageUrl = uploadResults['url'] ?? '';
      }

      final documentRef = firestore
          .collection('usuarios')
          .doc(mMasterSession.currentUsuario.value.id);

      final snapshot = await documentRef.get();
      if (snapshot.exists) {
        await documentRef.update({
          'apellidos': user.apellidos,
          'nombres': user.nombres,
          'celular': user.celular,
          'fechaNacimiento': user.fechaNacimiento,
          'urlPerfil': imageUrl,
          'edad': user.edad
        });
      } else {
        throw ('No se encontró la información del usuario');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> logOut() async {
    try {
      await auth.signOut();
    } catch (error) {
      customDialogFailed('Error', 'Hubo un error al cerrar la sesión: $error',
          () => {Get.back()});
    }
  }

  Future<void> actualizarUsuarioVerificado(Usuario usuario) async {
    try {
      final documentRef = firestore.collection('usuarios').doc(usuario.id);
      final snapshot = await documentRef.get();
      snapshot.exists ? await documentRef.update({'isVerified': true}) : null;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> sendEmailVerif() async {
    try {
      User? user = auth.currentUser;
      await user?.sendEmailVerification();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addDatosUsuario(Usuario user, String uid) async {
    try {
      final Map<String, dynamic> data = user.toMap();
      await firestore.collection('usuarios').doc(uid).set(data);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> registrarUsuarioFirebase(Usuario user) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: user.correo, password: user.password!);
    } catch (error) {
      rethrow;
    }
  }

  Future<Usuario?> getUsuario(String id) async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser != null) {
        final query = await firestore.collection('usuarios').doc(id).get();
        if (query.exists) {
          Map<String, dynamic> data = query.data() as Map<String, dynamic>;
          data['id'] = id;
          return Usuario.fromMap(data);
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Relacion?> getRelacion(String id) async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser != null) {
        final query = await firestore.collection('parejas').doc(id).get();
        if (query.exists) {
          Map<String, dynamic> data = query.data() as Map<String, dynamic>;
          data['id'] = id;
          return Relacion.fromMap(data);
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> registrarDevice() async {
    try {
      final documentRef = firestore
          .collection('usuarios')
          .doc(mMasterSession.currentUsuario.value.id);
      final snapshot = await documentRef.get();
      snapshot.exists
          ? await documentRef
              .update({'fcmToken': mMasterSession.fmcToken.value})
          : null;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> uploadImagen(String imagePath) async {
    Map<String, dynamic> results = {'success': false, 'url': ''};

    try {
      final String nombreArchivo = imagePath.split("/").last;
      final Reference ref =
          storage.ref().child("imagenesPerfil").child(nombreArchivo);
      final UploadTask uploadTask = ref.putFile(File(imagePath));
      final TaskSnapshot snapshot = await uploadTask;

      if (snapshot.state == TaskState.success) {
        final String urlImagen = await snapshot.ref.getDownloadURL();
        results['success'] = true;
        results['url'] = urlImagen;
      }
    } catch (e) {
      rethrow;
    }

    return results;
  }

  Future<void> deleteFileFromStorage(String fileUrl) async {
    try {
      Reference ref = FirebaseStorage.instance.refFromURL(fileUrl);
      await ref.delete();
    } catch (e) {
      rethrow;
    }
  }
}
