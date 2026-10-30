import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:navasys/features/dashboard_screen.dart';
import 'package:navasys/shared/states/cart_controller.dart';
import 'package:printing/printing.dart';

import '../../core/theme/app_colors.dart';
import '../models/demo/ticket_demo.dart';
import 'my_button.dart';
import 'dart:typed_data';

class SuccessPayment extends StatelessWidget {
  const SuccessPayment({super.key});

  void _irAlInicio(BuildContext context) {
    cart.vaciar();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
          (route) => false, // elimina todas las rutas anteriores
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // bloquea el botón atrás de Android y el gesto en iOS
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _irAlInicio(context); // si presiona atrás, lo manda al inicio
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              MyButton(
                icon: Icons.print,
                label: 'Imprimir',
                backgroundColor: AppColors.textPrimary,
                onPressed: () => _irAlInicio(context),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: MyButton(
                    icon: Icons.messenger_outline,
                    label: 'WhatsApp',
                    backgroundColor: AppColors.success,
                    onPressed: () => _irAlInicio(context),
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: MyButton(
                    icon: Icons.mail,
                    label: 'Correo',
                    backgroundColor: AppColors.primaryLight,
                    onPressed: () => _irAlInicio(context),
                  )),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: MyButton(
                    icon: Icons.download,
                    label: 'TICKET',
                    backgroundColor: AppColors.warning,
                    onPressed: () => _irAlInicio(context),
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: MyButton(
                    icon: Icons.home,
                    label: 'PDF',
                    backgroundColor: AppColors.danger,
                    onPressed: () => _irAlInicio(context),
                  )),
                ],
              ),
              const SizedBox(height: 12),
              Divider(
                color: AppColors.textHint,
                thickness: 1,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: PdfPreview(
                  build: (_) => generarTicketDemo(),
                  useActions: false,
                  canChangePageFormat: false,
                  canChangeOrientation: false,
                  canDebug: false,
                  pdfFileName: 'ticket.pdf',
                  maxPageWidth: 300, // para que el ticket no se estire a todo el ancho
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: MyButton(
                    label: 'Cerrar',
                    backgroundColor: AppColors.successDark,
                    onPressed: () => _irAlInicio(context),
                  )),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
