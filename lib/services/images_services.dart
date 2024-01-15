import 'package:image_picker/image_picker.dart';

Future getImagen() async {
  try {
    final ImagePicker picker = ImagePicker();
    final XFile? medias = await picker.pickImage(source: ImageSource.camera);
    return medias;
  } catch (e) {
    return null;
  }
}

Future<List<XFile>?> pickImages() async {
  try {
    final ImagePicker picker = ImagePicker();
    final List<XFile> medias = await picker.pickMultiImage();
    return medias;
  } catch (e) {
    return null;
  }
}

Future<XFile?> pickImage() async {
  try {
    final ImagePicker picker = ImagePicker();
    final XFile? medias = await picker.pickImage(source: ImageSource.gallery);
    return medias;
  } catch (e) {
    return null;
  }
}
