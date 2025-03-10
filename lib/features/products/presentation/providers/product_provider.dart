import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/products_repository_provider.dart';

//* El objetivo de este provider es encontrar un producto

// 3 - provider
final productProvider = StateNotifierProvider.autoDispose
    .family<ProductNotifier, ProductState, String>((ref, productId) {
  final productsRepository = ref.watch(productsRepositoryProvider);

  return ProductNotifier(
      productsRepository: productsRepository, productId: productId);
});

// 2 - Notifier
class ProductNotifier extends StateNotifier<ProductState> {
  // deberia poder recibir
  final ProductsRepository productsRepository;

//* necesitamos obtener los productId para que no haya duplicados
// cuando se crea la primera instancia va a ejecutar el método createNewProduct
  ProductNotifier({required this.productsRepository, required String productId})
      : super(ProductState(id: productId)) {
    loadProduct();
  }

  // creamos nuevo producto en blanco para la creación de uno nuevo
  Product _newEmptyProduct() {
    return Product(
        id: 'new',
        title: '',
        price: 0,
        description: '',
        slug: '',
        stock: 0,
        sizes: [],
        gender: '',
        tags: [],
        images: []);
  }

  Future<void> loadProduct() async {
    try {
      if (state.id == 'new') {
        state= state.copyWith(isLoading: false, product: _newEmptyProduct());
        return;
      }
      final product = await productsRepository.getProductsById(state.id);

      state = state.copyWith(isLoading: false, product: product);
    } catch (e) {
      // 404 product not found
      print(e);
    }
  }
}

// 1 - State
class ProductState {
  final String id;
  final Product? product;
  final bool isLoading;
  final bool isSaving;

  ProductState(
      {required this.id,
      this.product,
      this.isLoading = true,
      this.isSaving = false});
  // ahora el metodo copyWith
  ProductState copyWith({
    String? id,
    Product? product,
    bool? isLoading,
    bool? isSaving,
  }) =>
      ProductState(
          id: id ?? this.id,
          product: product ?? this.product,
          isLoading: isLoading ?? this.isLoading,
          isSaving: isSaving ?? this.isSaving);
}
