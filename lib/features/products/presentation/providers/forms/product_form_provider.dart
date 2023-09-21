import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/products_repository_provider.dart';

import '../../../../shared/shared.dart';

// 3 - provider


// 2 - Notifier
class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final void Function(Map<String, dynamic> productLike)? onSubmitCallback;

//* necesitamos obtener los productId para que no haya duplicados
// cuando se crea la primera instancia va a ejecutar el método createNewProduct
  ProductFormNotifier({this.onSubmitCallback, required Product product})
      : super(ProductFormState(
          id: product.id,
          title: Title.dirty(product.title),
          slug: Slug.dirty(product.slug),
          price: Price.dirty(product.price),
          inStock: Stock.dirty(product.stock),
          sizes: product.sizes,
          gender: product.gender,
          description: product.description,
          tags: product.tags.join(', '),
          images: product.images,
        ));
}

// 1 - State
class ProductFormState {
  final bool isformValid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final Stock inStock;
  final List<String> sizes;
  final String gender;
  final String description;
  final String tags;
  final List<String> images;

  ProductFormState({
    this.isformValid = false,
    this.id,
    this.title = const Title.dirty(''),
    this.slug = const Slug.dirty(''),
    this.price = const Price.dirty(0),
    this.inStock = const Stock.dirty(0),
    this.sizes = const [],
    this.gender = 'men',
    this.description = '',
    this.tags = '',
    this.images = const [],
  });

  // ahora el metodo copyWith
  ProductFormState copyWith(
          {String? id,
          bool? isformValid,
          Title? title,
          Slug? slug,
          Price? price,
          Stock? inStock,
          List<String>? sizes,
          String? gender,
          String? description,
          String? tags,
          List<String>? images}) =>
      ProductFormState(
          isformValid: isformValid ?? this.isformValid,
          id: id ?? this.id,
          title: title ?? this.title,
          slug: slug ?? this.slug,
          price: price ?? this.price,
          inStock: inStock ?? this.inStock,
          sizes: sizes ?? this.sizes,
          description: description ?? this.description,
          tags: tags ?? this.tags,
          images: images ?? this.images);
}
