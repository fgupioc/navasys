import 'package:flutter/foundation.dart';

import '../models/demo/Producto.dart';

class CartItem {
  final Producto producto;
  int cantidad;

  CartItem(this.producto, {this.cantidad = 1});

  double get precioUnitario => producto.precioOferta ?? producto.precio;

  double get subtotal => precioUnitario * cantidad;
}

class CartController extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();

  /// Total de unidades (lo que muestra el badge)
  int get totalUnidades => _items.values.fold(0, (sum, item) => sum + item.cantidad);

  double get total => _items.values.fold(0.0, (sum, item) => sum + item.subtotal);

  bool contiene(Producto p) => _items.containsKey(p.codigo);

  int cantidadDe(Producto p) => _items[p.codigo]?.cantidad ?? 0;

  /// Devuelve false si no hay stock suficiente
  bool agregar(Producto p) {
    final item = _items[p.codigo];
    if (item == null) {
      if (p.stock <= 0) return false;
      _items[p.codigo] = CartItem(p);
    } else {
      if (item.cantidad >= p.stock) return false;
      item.cantidad++;
    }
    notifyListeners();
    return true;
  }

  void quitarUno(Producto p) {
    final item = _items[p.codigo];
    if (item == null) return;
    item.cantidad--;
    if (item.cantidad <= 0) _items.remove(p.codigo);
    notifyListeners();
  }

  void eliminar(Producto p) {
    if (_items.remove(p.codigo) != null) notifyListeners();
  }

  void vaciar() {
    _items.clear();
    notifyListeners();
  }

  /// Suma a precio regular
  double get subtotal => _items.values
      .fold(0.0, (sum, i) => sum + i.producto.precio * i.cantidad);

  /// Ahorro por productos en oferta
  double get descuento => subtotal - total;
}

/// Instancia única compartida en la app
final cart = CartController();

