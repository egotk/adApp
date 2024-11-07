abstract interface class ImageStorageRepo {
  // загрузить с телефона
  Future<String?> uploadAdImageMobile(String path, String fileName);
}
