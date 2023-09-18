import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductsRepositoryImpl extends ProductsRepository {

  //* el unico objetivo del rep Impl es usar el datasource
  //* Es el datasource quien debe satisfacer toda la info
  final ProductsDatasource datasource;

  ProductsRepositoryImpl(this.datasource);

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productlike) {
    return datasource.createUpdateProduct(productlike);
  }

  @override
  Future<Product> getProductsById(String id) {
    return datasource.getProductsById(id);
  }

  @override
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0}) {
    return datasource.getProductsByPage(limit: limit, offset: offset);
  }

  @override
  Future<List<Product>> searchProductByTerm(String term) {
    return datasource.searchProductByTerm(term);
  }
}
