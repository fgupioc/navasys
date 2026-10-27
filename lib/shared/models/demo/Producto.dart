class Producto {
  final String nombre;
  final String codigo;
  final String imagenUrl;
  final double precio;
  final double? precioOferta;
  final int stock;

  const Producto({
    required this.nombre,
    required this.codigo,
    required this.imagenUrl,
    required this.precio,
    this.precioOferta,
    required this.stock,
  });
}

const _cdn = 'https://cdn.dummyjson.com/product-images/groceries';

const List<Producto> productos = [
  Producto(
    nombre: 'Leche entera 1L',
    codigo: 'PROD00001',
    imagenUrl: '$_cdn/milk/thumbnail.webp',
    precio: 5.00,
    precioOferta: 4.80,
    stock: 31,
  ),
  Producto(
    nombre: 'Huevos x 15 und',
    codigo: 'PROD00002',
    imagenUrl: '$_cdn/eggs/thumbnail.webp',
    precio: 9.50,
    stock: 24,
  ),
  Producto(
    nombre: 'Arroz extra 5kg',
    codigo: 'PROD00003',
    imagenUrl: '$_cdn/rice/thumbnail.webp',
    precio: 22.90,
    precioOferta: 19.90,
    stock: 18,
  ),
  Producto(
    nombre: 'Aceite vegetal 1L',
    codigo: 'PROD00004',
    imagenUrl: '$_cdn/cooking-oil/thumbnail.webp',
    precio: 10.50,
    stock: 40,
  ),
  Producto(
    nombre: 'Café instantáneo 200g',
    codigo: 'PROD00005',
    imagenUrl: '$_cdn/nescafe-coffee/thumbnail.webp',
    precio: 18.90,
    precioOferta: 16.50,
    stock: 12,
  ),
  Producto(
    nombre: 'Miel de abeja 500g',
    codigo: 'PROD00006',
    imagenUrl: '$_cdn/honey-jar/thumbnail.webp',
    precio: 14.00,
    stock: 9,
  ),
  Producto(
    nombre: 'Gaseosa 3L',
    codigo: 'PROD00007',
    imagenUrl: '$_cdn/soft-drinks/thumbnail.webp',
    precio: 11.50,
    precioOferta: 9.90,
    stock: 35,
  ),
  Producto(
    nombre: 'Agua mineral 625ml',
    codigo: 'PROD00008',
    imagenUrl: '$_cdn/water/thumbnail.webp',
    precio: 1.50,
    stock: 120,
  ),
  Producto(
    nombre: 'Jugo de naranja 1L',
    codigo: 'PROD00009',
    imagenUrl: '$_cdn/juice/thumbnail.webp',
    precio: 6.90,
    stock: 22,
  ),
  Producto(
    nombre: 'Papa amarilla 1kg',
    codigo: 'PROD00010',
    imagenUrl: '$_cdn/potatoes/thumbnail.webp',
    precio: 4.20,
    stock: 50,
  ),
  Producto(
    nombre: 'Cebolla roja 1kg',
    codigo: 'PROD00011',
    imagenUrl: '$_cdn/red-onions/thumbnail.webp',
    precio: 3.50,
    precioOferta: 2.90,
    stock: 45,
  ),
  Producto(
    nombre: 'Limón 1kg',
    codigo: 'PROD00012',
    imagenUrl: '$_cdn/lemon/thumbnail.webp',
    precio: 5.80,
    stock: 30,
  ),
  Producto(
    nombre: 'Pechuga de pollo 1kg',
    codigo: 'PROD00013',
    imagenUrl: '$_cdn/chicken-meat/thumbnail.webp',
    precio: 16.90,
    stock: 15,
  ),
  Producto(
    nombre: 'Helado 1L',
    codigo: 'PROD00014',
    imagenUrl: '$_cdn/ice-cream/thumbnail.webp',
    precio: 12.00,
    precioOferta: 10.50,
    stock: 8,
  ),
  Producto(
    nombre: 'Papel higiénico x 4',
    codigo: 'PROD00015',
    imagenUrl: '$_cdn/tissue-paper-box/thumbnail.webp',
    precio: 7.90,
    stock: 60,
  ),
];