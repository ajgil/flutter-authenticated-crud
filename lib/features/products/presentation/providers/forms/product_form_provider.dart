import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/products_provider.dart';

import '../../../../shared/shared.dart';

// 3 - provider
final productFormProvider = StateNotifierProvider.autoDispose
    .family<ProductFormNotifier, ProductFormState, Product>((ref, product) {
  
  final createUpdateCallback =
      ref.watch(productsProvider.notifier).createOrUpdateProduct; //regresa boolean
  
  return ProductFormNotifier(
      product: product, onSubmitCallback: createUpdateCallback);
});

// 2 - Notifier
class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final Future<bool> Function(Map<String, dynamic> productLike)?
      onSubmitCallback;

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

  Future<bool> onFormSubmit() async {
    _touchedEverything();
    if (!state.isformValid) return false;

    //TODO: regresar
    if (onSubmitCallback == null) return false;

    final productLike = {
      'id': (state.id == 'new') ? null : state.id,
      'title': state.title.value,
      'price': state.price.value,
      'description': state.description,
      'slug': state.slug.value,
      'stock': state.inStock.value,
      'sizes': state.sizes,
      'gender': state.gender,
      'tags': state.tags.split(','),
      'images': state.images
          .map((e) => e.replaceAll('${Environment.apiUrl}/files/product/', ''))
          .toList()
    };

    // todo -> llamar onSubmitCallback
    try {
      return await onSubmitCallback!(productLike);
    } catch (e) {
      return false;
    }
  }

// forzar que todos los campos han sido manipulados tocado todos los inputs
  void _touchedEverything() {
    state = state.copyWith(
        isformValid: Formz.validate([
      Title.dirty(state.title.value),
      Slug.dirty(state.slug.value),
      Stock.dirty(state.inStock.value),
      Price.dirty(state.price.value),
    ]));
  }

  void onTitleChanged(String value) {
    state = state.copyWith(
      title: Title.dirty(value),
      isformValid: Formz.validate([
        Title.dirty(value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value)
      ]),
    );
  }

  void onSlugChanged(String value) {
    state = state.copyWith(
      slug: Slug.dirty(value),
      isformValid: Formz.validate([
        Slug.dirty(value),
        Title.dirty(state.title.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value)
      ]),
    );
  }

  void onPriceChanged(double value) {
    state = state.copyWith(
      price: Price.dirty(value),
      isformValid: Formz.validate([
        Price.dirty(value),
        Title.dirty(state.title.value),
        Slug.dirty(state.slug.value),
        Stock.dirty(state.inStock.value)
      ]),
    );
  }

  void onStockChanged(int value) {
    state = state.copyWith(
      inStock: Stock.dirty(value),
      isformValid: Formz.validate([
        Stock.dirty(value),
        Title.dirty(state.title.value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value)
      ]),
    );
  }

  void onSizedChanged(List<String> sizes) {
    state = state.copyWith(sizes: sizes);
  }

  void onGenderChanged(String gender) {
    state = state.copyWith(gender: gender);
  }

  void onDescriptionChanged(String description) {
    state = state.copyWith(description: description);
  }

  void onTagsChanged(String tags) {
    state = state.copyWith(tags: tags);
  }
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
