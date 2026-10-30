import 'package:flutter/material.dart';
import 'package:navasys/shared/models/demo/Producto.dart';

import '../core/theme/app_colors.dart';
import '../shared/widgets/app_date_field.dart';

class MovimientosTabScreen extends StatefulWidget {
  const MovimientosTabScreen({super.key});

  @override
  State<MovimientosTabScreen> createState() => _MovimientosTabScreenState();
}

class _MovimientosTabScreenState extends State<MovimientosTabScreen> {
  DateTime? _fechaPago = DateTime.now();
  final _dateInitCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateInitCtrl.text = AppDateField.format(_fechaPago!);
  }

  @override
  void dispose() {
    _dateInitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: 'Todos',
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 'Todos', child: Text('Todos')),
                    DropdownMenuItem(value: 'Entrada', child: Text('Entrada')),
                    DropdownMenuItem(value: 'Salida', child: Text('Salida')),
                    DropdownMenuItem(
                      value: 'Transferencia',
                      child: Text('Transferencia'),
                    ),
                  ],
                  onChanged: (value) {
                    // Handle selection change
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.textPrimary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.textPrimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF1673ED), width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppDateField(
                  hint: 'Selecciona una fecha',
                  controller: _dateInitCtrl,
                  value: _fechaPago,
                  onChanged: (d) => setState(() => _fechaPago = d),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Selecciona una fecha' : null,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 50),
            itemCount: productos.length,
            itemBuilder: (_, i) => BuildMovementItem(),
          ),
        ),
      ],
    );
  }
}

class BuildMovementItem extends StatelessWidget {
  const BuildMovementItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColors.successSoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Normal',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.successDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aceite Cocinero 1l',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 0),
                    Text(
                      '10:32 am',
                      style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '+10',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.successDark),
                  ),
                  const SizedBox(height: 0),
                  Text(
                    'Proveedor',
                    style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: AppColors.textHint, thickness: 1),
        ],
      ),
    );
  }
}
