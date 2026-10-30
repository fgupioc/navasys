import 'package:flutter/material.dart';
import 'package:navasys/shared/widgets/customer_select.dart';
import 'package:navasys/shared/widgets/my_alert.dart';
import 'package:navasys/shared/widgets/success_payment.dart';

import '../../core/theme/app_colors.dart';
import '../models/customer.dart';
import '../states/cart_controller.dart';
import 'app_text_field.dart';

class ProcessPayment extends StatefulWidget {
  const ProcessPayment({super.key});

  @override
  State<ProcessPayment> createState() => _ProcessPaymentState();
}

class _ProcessPaymentState extends State<ProcessPayment> {
  List<Customer> _customers = [];
  bool _selectingCustomer = true;
  Customer? customerSeleccionado;
  String? _selectedPaymentMethod;

  Future<void> _processPay() async {
    /*
    if (customerSeleccionado == null) {
      setState(() {
        _selectingCustomer = false;
      });
      return;
    }
*/
    final ok = await MyAlert.confirm(
      context,
      title: 'Confirmar pago',
      text: '¿Está seguro de que desea procesar el pago?',
      confirmText: 'Sí, procesar',
      cancelText: 'Cancelar',
      type: AlertType.question,
      confirmColor: AppColors.success,
    );
    if (ok != true) return;



    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SuccessPayment(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: cart,
      builder: (context, _) {
        final items = cart.items;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: Text(
              'Cobrar (${cart.totalUnidades})',
              style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
          ),
          body: _buildBody(items),
        );
      },
    );
  }

  Widget? _buildBody(List<CartItem> items) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  'Cliente',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textPrimary.withValues(alpha: 0.8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                CustomerSelect(
                  customers: _customers,
                  initialValue: customerSeleccionado,
                  onChanged: (socio) {
                    setState(() {
                      customerSeleccionado = socio;
                      _selectingCustomer = socio != null;
                    });
                  },
                ),
                if (_selectingCustomer == false)
                  Text(
                    'Debe seleccionar un cliente',
                    style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () async {
                        /*
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManageCustomerScreen(),
                        ),
                      );
                      await _refreshCustomers();
                      */
                      },
                      icon: const Icon(Icons.person_add_alt_1),
                      label: const Text('Agregar cliente'),
                    ),
                  ],
                ),
                Text(
                  'Comprobante',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textPrimary.withValues(alpha: 0.8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: 'Nota',
                        items: const [
                          DropdownMenuItem(value: 'Nota', child: Text('Nota de venta')),
                          DropdownMenuItem(value: 'Boleta', child: Text('Boleta')),
                          DropdownMenuItem(value: 'Factura', child: Text('Factura')),
                        ],
                        onChanged: (value) {
                          // Handle selection change
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
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
                            borderSide: const BorderSide(
                              color: Color(0xFF1673ED),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Serie',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.textPrimary.withValues(alpha: 0.8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AppTextField(
                            controller: TextEditingController(),
                            hint: 'B001',
                            icon: Icons.confirmation_number_outlined,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Descuento',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.textPrimary.withValues(alpha: 0.8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AppTextField(
                            keyboardType: TextInputType.number,
                            controller: TextEditingController(),
                            hint: '0.00',
                            icon: Icons.percent,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    MethodPayment(
                      icon: 'cash-payment.png',
                      label: 'Efectivo',
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 'Efectivo';
                        });
                      },
                      isSelected: _selectedPaymentMethod == 'Efectivo',
                    ),
                    const SizedBox(width: 8),
                    MethodPayment(
                      icon: 'yape.png',
                      label: 'Yape',
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 'Yape';
                        });
                      },
                      isSelected: _selectedPaymentMethod == 'Yape',
                    ),
                    const SizedBox(width: 8),
                    MethodPayment(
                      icon: 'bank-transfer.png',
                      label: 'Transferencia',
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 'Transferencia';
                        });
                      },
                      isSelected: _selectedPaymentMethod == 'Transferencia',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Divider(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('IGV', style: TextStyle(fontSize: 16)),
                          Text(
                            'S/ ${cart.total}',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Descuento', style: TextStyle(fontSize: 16)),
                          Text(
                            'S/ ${cart.total}',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total a pagar',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'S/ ${cart.total}',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.success,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: AppColors.textSecondary.withValues(alpha: 0.5), width: 1),
                          ),
                        ),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _processPay(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: AppColors.textSecondary.withValues(alpha: 0.5), width: 1),
                          ),
                        ),
                        child: Text(
                          'Confirmar pago',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MethodPayment extends StatelessWidget {
  final bool isSelected;
  final String icon;
  final String label;
  final VoidCallback? onTap;

  const MethodPayment({
    super.key,
    this.isSelected = false,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.info.withValues(alpha: 0.4) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.info
                  : AppColors.textPrimary.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              Image.asset('assets/images/$icon', width: 40, height: 40),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
