import 'package:bloc/bloc.dart';
import 'package:store/store/products/detail/product_detail_repository.dart';
import 'package:store/store/products/product/product.dart';

import 'cart_bloc_event.dart';
import 'cart_product.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final List<CartProduct> _products = [];
  final ProductDetailRepository _detailRepo;

  CartBloc(this._detailRepo);

  @override
  CartState get initialState => CartLoading();

  int getTotalCount() {
    int count = 0;
    _products.forEach((cp) {
      count += cp.count;
    });

    return count;
  }

  int getCount(Product product) {
    if (_cartContainsProduct(product)) {
      return _products.firstWhere((cp) => cp.product == product).count;
    } else {
      return 0;
    }
  }

  int getTotal() {
    int total = 0;

    _products.forEach((cp) {
      total += cp.count * cp.product.price.amount;
    });

    return total;
  }

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is FetchCart) {
      yield CartLoading();
      if (_products.isEmpty) {
        yield CartEmpty();
      } else {
        yield CartLoaded(_products, getTotalCount(), getTotal());
      }
    } else if (event is Add) {
      yield CartLoading();
      _addProduct(event.product);
      yield CartLoaded(_products, getTotalCount(), getTotal());
    } else if (event is Clear) {
      yield CartLoading();
      _products.clear();
      yield CartEmpty();
    } else if (event is Remove) {
      yield CartLoading();
      print("11111111111");
      _removeProduct(event.product);
      print("11111111221");

      if (_products.isEmpty) {
        print("11111111113");
        yield CartEmpty();
      } else {
        print("11111111112");
        yield CartLoaded(_products, getTotalCount(), getTotal());
      }
    }
  }

  bool _cartContainsProduct(Product product) {
    bool res = false;
    _products.forEach((p) {
      if (p.product == product) {
        res = true;
      }
    });
    return res;
  }

  _addProduct(Product product) {
    if (!_cartContainsProduct(product)) {
      _products.add(CartProduct(product, 1));
      _detailRepo.load(product.id);
    } else {
      _products.forEach((cartProduct) {
        if (cartProduct.product == product) {
          cartProduct.addOne();
        }
      });
    }

    print("add called: " + _products.toString());
  }

  _removeProduct(Product product) {
    print("alsidja" + _products.toString());
    if (_cartContainsProduct(product)) {
      if (_products.map((cp) => cp.product).contains(product)) {
        CartProduct foundCP =
            _products.firstWhere((cp) => cp.product == product);
        foundCP.removeOne();

        if (foundCP.count == 0) {
          _products.remove(foundCP);
        }
      }
    }
  }
}
