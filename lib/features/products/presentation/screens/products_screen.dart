import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/products/presentation/providers/products_provider.dart';
import 'package:teslo_shop/features/products/presentation/widgets/widgets.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: const _ProductsView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Nuevo producto'),
        icon: const Icon(Icons.add),
        onPressed: () {
          context.push('/product/new');
        },
      ),
    );
  }
}

class _ProductsView extends ConsumerStatefulWidget {
  const _ProductsView();

  @override
  _ProductsViewState createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState<_ProductsView> {
  // controlador
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // leer el provider
    // todo -> infinite scroll pendiente
    // 1- conectar el scrollController al grid
    // 2- add listener al initState
    scrollController.addListener(() {
      if ((scrollController.position.pixels + 400) >=
          scrollController.position.maxScrollExtent) {
        ref.read(productsProvider.notifier).loadNextPage();
      }
    });
    ref.read(productsProvider.notifier).loadNextPage();
    // 400 px margen de gracia hacer otra llamada
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: MasonryGridView.count(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 35,
          itemCount: productsState.products
              .length, //basado en los productos que disponemos en el state
          itemBuilder: (context, index) {
            final product = productsState.products[index];
            return GestureDetector(
              onTap: () => context.push('/product/${product.id}'),
              child: ProductCard(product: product),
            ); //creamos la referencia y ganamos legibilidad y no hay un coste de memoria alta ya que es un puntero a la posición de memoria del objeto
          },
        ));
  }
}
