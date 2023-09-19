//* provee a toda la app el acceso a la implementación del repositorio de productos y (datasource)

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/products/infrastructure/datasources/products_datasource_impl.dart';
import 'package:teslo_shop/features/products/infrastructure/repositories/products_repository_impl.dart';
import '../../domain/domain.dart';

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  //* hay que regresar la instancia
  //* el accessToken lo tenemos en otro provider, asi que obtenemos el token mediante el arbol de providers usando ref

  final accessToken = ref.watch(authProvider).user?.token ??
      ''; // al ser un watch cualquier cambio dentro del auth se actualiza aqui

  final productsRepository =
      ProductsRepositoryImpl(ProductsDatasourceImpl(accessToken: accessToken));

  return productsRepository;
});
