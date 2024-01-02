import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:nuestra_historia/controller/mastersession_controller.dart';
import 'package:nuestra_historia/models/usuario_model.dart';
import 'package:nuestra_historia/screens/home/home_screen.dart';
import 'package:nuestra_historia/screens/login/login_screen.dart';
import 'package:nuestra_historia/screens/widgets/dialog.dart';

class AuthController extends GetxController {
  static AuthController instace = Get.find();
  late Rx<User?> user;
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
      final usuario = await getUsuario();
      bool veri = user.emailVerified;
      if (veri) {
        if (usuario != null && !usuario.isVerified) {
          await actualizarUsuarioVerificado(usuario);
        }
        mMasterSession.listenToUserChanges(user.uid);
        mMasterSession.currentUsuario.value = usuario!;
        Get.offAll(() => const HomeScreen());
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
            Get.to(() => const LoginScreen());
          },
        );
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
      customDialogFailed('Error', 'Hubo un error al iniciar sesion: $error');
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
      customDialogFailed('Error', 'Hubo un error al crear el usuario: $error');
    }
  }

  Future<void> logOut() async {
    try {
      await auth.signOut();
    } catch (error) {
      customDialogFailed('Error', 'Hubo un error al cerrar la sesión: $error');
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

  Future<Usuario?> getUsuario() async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser != null) {
        final query =
            await firestore.collection('usuarios').doc(currentUser.uid).get();
        if (query.exists) {
          Map<String, dynamic> data = query.data() as Map<String, dynamic>;
          data['id'] = currentUser.uid;
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
}
