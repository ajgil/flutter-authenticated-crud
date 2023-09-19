// StateNotifierProvider
// como indica el nombre, dispone:
// 1.- State
// 2.- Notifier
// 3.- Provider

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/presentation/providers/products_repository_provider.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/products_repository.dart';


// 3 - provider
final productsProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return ProductsNotifier(productsRepository: productsRepository);
});

// 2 - Notifier
class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductsRepository productsRepository;

// cuando se crea la primera instancia va a ejecutar el método loadNextPage
  ProductsNotifier({required this.productsRepository})
      : super(ProductsState()) {
    loadNextPage();
  }

  Future loadNextPage() async {
    // para que no bombardeen este metodo
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);

    // necesitamos el repositorio
    final products = await productsRepository.getProductsByPage(
        limit: state.limit, offset: state.offset);
    if (products.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        isLastPage: true,
      );
      return;
    }
    // si queda mas de 0
    state = state.copyWith(
        isLoading: false,
        isLastPage: false,
        offset: state.offset + 10,
        products: [...state.products, ...products]);
  }
}

// 1 - State
class ProductsState {
  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Product> products;

  ProductsState(
      {this.isLastPage = false,
      this.limit = 10,
      this.offset = 0,
      this.isLoading = false,
      this.products = const []});

  // ahora el metodo copyWith
  ProductsState copyWith(
          {bool? isLastPage,
          int? limit,
          int? offset,
          bool? isLoading,
          List<Product>? products}) =>
      ProductsState(
          isLastPage: isLastPage ?? this.isLastPage,
          limit: limit ?? this.limit,
          offset: offset ?? this.offset,
          isLoading: isLoading ?? this.isLoading,
          products: products ?? this.products);
}
