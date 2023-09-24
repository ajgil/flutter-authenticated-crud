//* Implementamos patro adaptador
//* para si en un futuro queremos cambiar la libreria image_picker no tengamos que estar modificando multiples ficheros

abstract class CameraGalleryService {

  Future<String?> takePhoto();
  Future<String?> selectPhoto();
  Future<List<String?>> selectMultiplePhotos();

}
// ahora hacemos la implementación