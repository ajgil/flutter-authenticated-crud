// definicion de las reglas de negocio
import '../entities/product.dart';

abstract class ProductsRepository {
  
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0});
  
  Future<Product> getProductsById(String id);

  Future<List<Product>> searchProductByTerm(String term);
  
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike); // puede ser o no un producto, se asemeja a un producto

}