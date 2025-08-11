import 'package:flutter/material.dart';
import 'package:pos_vesatogo/core/constants/app_colors.dart';
import 'package:pos_vesatogo/features/pos/data/models/product.dart';
import 'package:pos_vesatogo/features/pos/presentation/widgets/product_grid.dart';
import 'package:pos_vesatogo/features/pos/presentation/widgets/cart_sidebar.dart';
import 'package:pos_vesatogo/features/pos/presentation/widgets/category_filter.dart';
import 'package:pos_vesatogo/features/pos/providers/cart_provider.dart';
import 'package:pos_vesatogo/features/pos/providers/product_provider.dart';
import 'package:provider/provider.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> with TickerProviderStateMixin {
  late final TabController _tabController;
  bool _showCart = false;
  final TextEditingController _searchController = TextEditingController();

  final _categories = const [
    'All',
    'Beverages',
    'Chat',
    'Aam ras',
    'Drinking Water',
    'Dryfruit',
    'Dryfruit Mastani',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);

    // Load products when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });

    // Listen to tab changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        final category = _categories[_tabController.index];
        context.read<ProductProvider>().setCategory(category);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onProductTap(Product product) {
    context.read<CartProvider>().addProduct(product);

    setState(() {
      _showCart = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            // Left side - Product Grid
            Expanded(
              flex: _showCart ? 2 : 1,
              child: Column(
                children: [
                  _buildTopBar(),
                  _buildCategoryTabs(),
                  _buildSearchBar(),
                  Expanded(
                    child: Consumer<ProductProvider>(
                      builder: (context, productProvider, child) {
                        if (productProvider.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return Expanded(
                          child: Consumer<ProductProvider>(
                            builder: (context, productProvider, child) {
                              if (productProvider.isLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              return ProductGrid(
                                isCartOpen: _showCart,
                                products: productProvider.products,
                                onProductTap:
                                    _onProductTap, // This now receives the product
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  _buildBottomBar(),
                ],
              ),
            ),

            // Right side - Cart Sidebar
            if (_showCart)
              SizedBox(
                width: 450,
                child: CartSidebar(
                  onClose: () => setState(() => _showCart = false),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.menu, color: Colors.white),
          const SizedBox(width: 8),
          const Text(
            'Billing  /  New Order',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white24,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            onPressed: () {
              context.read<ProductProvider>().refreshProducts();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return CategoryFilter(tabController: _tabController, labels: _categories);
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (query) {
                context.read<ProductProvider>().setSearchQuery(query);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart),
            label: const Text('Running Orders'),
            style: ElevatedButton.styleFrom(foregroundColor: AppColors.primary),
          ),
          OutlinedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.back_hand_outlined),
            label: const Text('Start Order'),
          ),
          OutlinedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.print_rounded),
            label: const Text('Reprint'),
          ),
          OutlinedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.print_rounded),
            label: const Text('Print KOT'),
          ),
        ],
      ),
    );
  }
}
