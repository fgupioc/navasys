// lib/features/ventas/ticket_demo.dart
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generarTicketDemo() async {
  final doc = pw.Document();

  final items = [
    {'desc': 'Gaseosa 500ml', 'cant': 2, 'precio': 2.50},
    {'desc': 'Pan francés', 'cant': 6, 'precio': 0.30},
    {'desc': 'Leche Gloria 400g', 'cant': 1, 'precio': 4.20},
    {'desc': 'Gaseosa 500ml', 'cant': 2, 'precio': 2.50},
    {'desc': 'Pan francés', 'cant': 6, 'precio': 0.30},
    {'desc': 'Leche Gloria 400g', 'cant': 1, 'precio': 4.20},
    {'desc': 'Gaseosa 500ml', 'cant': 2, 'precio': 2.50},
    {'desc': 'Pan francés', 'cant': 6, 'precio': 0.30},
    {'desc': 'Leche Gloria 400g', 'cant': 1, 'precio': 4.20},
    {'desc': 'Gaseosa 500ml', 'cant': 2, 'precio': 2.50},
    {'desc': 'Pan francés', 'cant': 6, 'precio': 0.30},
    {'desc': 'Leche Gloria 400g', 'cant': 1, 'precio': 4.20},
    {'desc': 'Gaseosa 500ml', 'cant': 2, 'precio': 2.50},
    {'desc': 'Pan francés', 'cant': 6, 'precio': 0.30},
    {'desc': 'Leche Gloria 400g', 'cant': 1, 'precio': 4.20},
    {'desc': 'Gaseosa 500ml', 'cant': 2, 'precio': 2.50},
    {'desc': 'Pan francés', 'cant': 6, 'precio': 0.30},
    {'desc': 'Leche Gloria 400g', 'cant': 1, 'precio': 4.20},
    {'desc': 'Gaseosa 500ml', 'cant': 2, 'precio': 2.50},
    {'desc': 'Pan francés', 'cant': 6, 'precio': 0.30},
    {'desc': 'Leche Gloria 400g', 'cant': 1, 'precio': 4.20},
    {'desc': 'Gaseosa 500ml', 'cant': 2, 'precio': 2.50},
    {'desc': 'Pan francés', 'cant': 6, 'precio': 0.30},
    {'desc': 'Leche Gloria 400g', 'cant': 1, 'precio': 4.20}, {'desc': 'Gaseosa 500ml', 'cant': 2, 'precio': 2.50},
    {'desc': 'Pan francés', 'cant': 6, 'precio': 0.30},
    {'desc': 'Leche Gloria 400g', 'cant': 1, 'precio': 4.20},
    {'desc': 'Gaseosa 500ml', 'cant': 2, 'precio': 2.50},
    {'desc': 'Pan francés', 'cant': 6, 'precio': 0.30},
    {'desc': 'Leche Gloria 400g', 'cant': 1, 'precio': 4.20},
    {'desc': 'Gaseosa 500ml', 'cant': 2, 'precio': 2.50},
    {'desc': 'Pan francés', 'cant': 6, 'precio': 0.30},
    {'desc': 'Leche Gloria 400g', 'cant': 1, 'precio': 4.20},
    {'desc': 'Gaseosa 500ml', 'cant': 2, 'precio': 2.50},
    {'desc': 'Pan francés', 'cant': 6, 'precio': 0.30},
    {'desc': 'Leche Gloria 400g', 'cant': 1, 'precio': 4.20},
    {'desc': 'Gaseosa 500ml', 'cant': 2, 'precio': 2.50},
    {'desc': 'Pan francés', 'cant': 6, 'precio': 0.30},
    {'desc': 'Leche Gloria 400g', 'cant': 1, 'precio': 4.20},
    {'desc': 'Gaseosa 500ml', 'cant': 2, 'precio': 2.50},
    {'desc': 'Pan francés', 'cant': 6, 'precio': 0.30},
    {'desc': 'Leche Gloria 400g', 'cant': 1, 'precio': 4.20},
    {'desc': 'Gaseosa 500ml', 'cant': 2, 'precio': 2.50},
    {'desc': 'Pan francés', 'cant': 6, 'precio': 0.30},
    {'desc': 'Leche Gloria 400g', 'cant': 1, 'precio': 4.20},
    {'desc': 'Gaseosa 500ml', 'cant': 2, 'precio': 2.50},
    {'desc': 'Pan francés', 'cant': 6, 'precio': 0.30},
    {'desc': 'Leche Gloria 400g', 'cant': 1, 'precio': 4.20},

  ];

  final total = items.fold<double>(
      0, (s, i) => s + (i['cant'] as int) * (i['precio'] as double));
  final subtotal = total / 1.18;
  final igv = total - subtotal;

  pw.Widget fila(String a, String b, {bool bold = false}) => pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Text(a, style: pw.TextStyle(fontWeight: bold ? pw.FontWeight.bold : null)),
      pw.Text(b, style: pw.TextStyle(fontWeight: bold ? pw.FontWeight.bold : null)),
    ],
  );

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.roll80, // ticket de 80mm, alto automático
      margin: const pw.EdgeInsets.all(8),
      build: (_) => pw.DefaultTextStyle(
        style: const pw.TextStyle(fontSize: 8),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.Center(
              child: pw.Text('MI MINIMARKET',
                  style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            ),
            pw.Center(child: pw.Text('RUC 20123456789')),
            pw.Center(child: pw.Text('Av. Principal 123 - Lima')),
            pw.SizedBox(height: 6),
            pw.Center(
              child: pw.Text('BOLETA DE VENTA ELECTRÓNICA',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Center(child: pw.Text('B001-00000001')),
            pw.SizedBox(height: 4),
            pw.Text('Fecha: 30/10/2026 11:50'),
            pw.Text('Cliente: CLIENTES VARIOS'),
            pw.Divider(borderStyle: pw.BorderStyle.dashed),

            // Cabecera de items
            pw.Row(children: [
              pw.Expanded(flex: 5, child: pw.Text('Descripción', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              pw.Expanded(flex: 1, child: pw.Text('Cant', textAlign: pw.TextAlign.right, style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              pw.Expanded(flex: 2, child: pw.Text('Importe', textAlign: pw.TextAlign.right, style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
            ]),
            ...items.map((i) {
              final importe = (i['cant'] as int) * (i['precio'] as double);
              return pw.Row(children: [
                pw.Expanded(flex: 5, child: pw.Text(i['desc'] as String)),
                pw.Expanded(flex: 1, child: pw.Text('${i['cant']}', textAlign: pw.TextAlign.right)),
                pw.Expanded(flex: 2, child: pw.Text(importe.toStringAsFixed(2), textAlign: pw.TextAlign.right)),
              ]);
            }),
            pw.Divider(borderStyle: pw.BorderStyle.dashed),

            fila('Op. Gravada', 'S/ ${subtotal.toStringAsFixed(2)}'),
            fila('IGV (18%)', 'S/ ${igv.toStringAsFixed(2)}'),
            fila('TOTAL', 'S/ ${total.toStringAsFixed(2)}', bold: true),
            pw.SizedBox(height: 4),
            pw.Text('Pago: Efectivo'),
            pw.SizedBox(height: 8),
            pw.Center(
              child: pw.BarcodeWidget(
                barcode: pw.Barcode.qrCode(),
                data: '20123456789|03|B001|00000001|${igv.toStringAsFixed(2)}|${total.toStringAsFixed(2)}|30/10/2026',
                width: 70,
                height: 70,
              ),
            ),
            pw.SizedBox(height: 6),
            pw.Center(child: pw.Text('¡Gracias por su compra!')),
          ],
        ),
      ),
    ),
  );

  return doc.save();
}