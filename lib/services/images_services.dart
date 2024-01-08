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

Future<List<XFile>?> pickImages(ImageSource source) async {
  try {
    final ImagePicker picker = ImagePicker();
    final List<XFile> medias = await picker.pickMultiImage();
    return medias;
  } catch (e) {
    return null;
  }
}
