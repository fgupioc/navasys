import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../shared/models/demo/Producto.dart';
import '../shared/states/cart_controller.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen>
    with SingleTickerProviderStateMixin {
  static const _dark = Color(0xFF1E2A5A);
  static const _blue = Color(0xFF2563EB);

  String? _ultimoCodigo;
  DateTime _ultimaLectura = DateTime(0);

  final _scanner = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    detectionTimeoutMs: 150,
    cameraResolution: const Size(1280, 720), // solo aplica en Android
    formats: const [
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.upcA,
      BarcodeFormat.code128,
    ],
  );

  late final AnimationController _linea = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat(reverse: true);

  Producto? _producto;
  int _cantidad = 1;
  bool _bloqueado = false;

  @override
  void dispose() {
    _linea.dispose();
    _scanner.dispose();
    super.dispose();
  }
  void _onDetect(BarcodeCapture capture) {
    if (_producto != null) return;
    final code = capture.barcodes.firstOrNull?.rawValue;
    if (code == null) return;

    final ahora = DateTime.now();
    if (code == _ultimoCodigo &&
        ahora.difference(_ultimaLectura) < const Duration(seconds: 2)) {
      return; // mismo código hace un momento, lo ignoramos
    }
    _ultimoCodigo = code;
    _ultimaLectura = ahora;

    final p = buscarPorCodigo(code);
    if (p == null) {
      _snack('Producto no encontrado: $code');
      return; // en 2 s puede volver a intentarlo sin salir
    }

    HapticFeedback.mediumImpact();
    setState(() {
      _producto = p;
      _cantidad = 1;
    });
  }

  void _cerrarPanel() {
    _ultimaLectura = DateTime.now(); // evita que se reabra al instante
    setState(() => _producto = null);
  }

  void _agregar() {
    final p = _producto!;
    if (cart.agregarCantidad(p, _cantidad)) {
      _snack('$_cantidad × ${p.nombre} agregado al carrito');
      setState(() => _producto = null); // sigue escaneando
    } else {
      _snack('No hay stock suficiente');
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: _dark,
        title: const Text(
          'Escanear código de barras',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        actions: [
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: _scanner,
            builder: (_, state, __) {
              final on = state.torchState == TorchState.on;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: IconButton.filledTonal(
                  onPressed: _scanner.toggleTorch,
                  icon: Icon(on ? Icons.flash_on : Icons.flash_off),
                ),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth * 0.78;
          const h = 200.0;
          final window = Rect.fromCenter(
            center: Offset(c.maxWidth / 2, c.maxHeight * 0.32),
            width: w,
            height: h,
          );

          return Stack(
            children: [
              // Cámara
              Positioned.fill(
                child: MobileScanner(
                  controller: _scanner,
                  scanWindow: window,
                  onDetect: _onDetect,
                ),
              ),

              // Oscurecido + esquinas
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(painter: _ScanOverlay(window)),
                ),
              ),

              // Línea roja animada
              AnimatedBuilder(
                animation: _linea,
                builder: (_, __) => Positioned(
                  left: window.left - 12,
                  width: window.width + 24,
                  top: window.top + 8 + (window.height - 16) * _linea.value,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.redAccent.withOpacity(0.6),
                            blurRadius: 6),
                      ],
                    ),
                  ),
                ),
              ),

              // Mensaje guía
              Positioned(
                top: window.bottom + 24,
                left: window.left,
                width: window.width,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: _dark.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.qr_code_scanner, color: Colors.white),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Coloca el código de barras dentro del marco para escanear',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Panel del producto
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, anim) => SlideTransition(
                    position: Tween(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(anim),
                    child: child,
                  ),
                  child: _producto == null
                      ? const SizedBox.shrink()
                      : _panelProducto(_producto!),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _panelProducto(Producto p) {
    final disponible = p.stock - cart.cantidadDe(p);
    final precio = p.precioOferta ?? p.precio;
    final enOferta = p.precioOferta != null && p.precioOferta! < p.precio;
    final hayStock = disponible > 0;

    return Container(
      key: ValueKey(p.codigo),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => setState(() => _producto = null),
                icon: const Icon(Icons.close),
                visualDensity: VisualDensity.compact,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 116,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF4FB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.network(
                    p.imagenUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported_outlined),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.nombre,
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: _dark)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'S/ ${precio.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: enOferta
                                  ? const Color(0xFFF97316)
                                  : _dark,
                            ),
                          ),
                          if (enOferta) ...[
                            const SizedBox(width: 8),
                            Text(
                              'S/ ${p.precio.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      _chipStock(disponible),
                      if (p.descripcion != null) ...[
                        const SizedBox(height: 8),
                        Text(p.descripcion!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 13, color: Color(0xFF64748B))),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Cantidad',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: _dark, fontSize: 15)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _circleBtn(Icons.remove,
                      _cantidad > 1 ? () => setState(() => _cantidad--) : null),
                  SizedBox(
                    width: 70,
                    child: Text('$_cantidad',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: _dark)),
                  ),
                  _circleBtn(
                      Icons.add,
                      _cantidad < disponible
                          ? () => setState(() => _cantidad++)
                          : null),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: hayStock ? _agregar : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _blue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.add_shopping_cart),
                label: Text(
                  hayStock ? 'Agregar al carrito' : 'Sin stock disponible',
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chipStock(int disponible) {
    final ok = disponible > 0;
    final color = ok ? const Color(0xFF16A34A) : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: color),
          const SizedBox(width: 6),
          Text('Stock: $disponible',
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback? onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        fixedSize: const Size(46, 46),
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        foregroundColor: _blue,
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Icon(icon),
    );
  }
}

/// Oscurece todo menos el marco y dibuja las esquinas
class _ScanOverlay extends CustomPainter {
  final Rect window;
  _ScanOverlay(this.window);

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(window, const Radius.circular(16));

    final fondo = Path()
      ..addRect(Offset.zero & size)
      ..addRRect(rrect)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(fondo, Paint()..color = Colors.black.withOpacity(0.5));

    final p = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    const l = 36.0, r = 16.0;
    final w = window;

    // superior izquierda
    canvas.drawPath(
        Path()
          ..moveTo(w.left, w.top + l)
          ..lineTo(w.left, w.top + r)
          ..arcToPoint(Offset(w.left + r, w.top), radius: const Radius.circular(r))
          ..lineTo(w.left + l, w.top),
        p);
    // superior derecha
    canvas.drawPath(
        Path()
          ..moveTo(w.right - l, w.top)
          ..lineTo(w.right - r, w.top)
          ..arcToPoint(Offset(w.right, w.top + r), radius: const Radius.circular(r))
          ..lineTo(w.right, w.top + l),
        p);
    // inferior derecha
    canvas.drawPath(
        Path()
          ..moveTo(w.right, w.bottom - l)
          ..lineTo(w.right, w.bottom - r)
          ..arcToPoint(Offset(w.right - r, w.bottom), radius: const Radius.circular(r))
          ..lineTo(w.right - l, w.bottom),
        p);
    // inferior izquierda
    canvas.drawPath(
        Path()
          ..moveTo(w.left + l, w.bottom)
          ..lineTo(w.left + r, w.bottom)
          ..arcToPoint(Offset(w.left, w.bottom - r), radius: const Radius.circular(r))
          ..lineTo(w.left, w.bottom - l),
        p);
  }

  @override
  bool shouldRepaint(_ScanOverlay old) => old.window != window;
}