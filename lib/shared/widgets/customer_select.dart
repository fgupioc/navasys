import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../models/customer.dart';

class CustomerSelect extends StatefulWidget {
  final List<Customer> customers;
  final ValueChanged<Customer?> onChanged;
  final Customer? initialValue;

  const CustomerSelect({
    super.key,
    required this.customers,
    required this.onChanged,
    this.initialValue,
  });

  @override
  State<CustomerSelect> createState() => _CustomerSelectState();
}

class _CustomerSelectState extends State<CustomerSelect> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Customer? _customerSeleccionado;
  bool _limpiando = false;

  @override
  void initState() {
    super.initState();
    _aplicarValorInicial(widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _limpiarSeleccion() {
    setState(() {
      _limpiando = true;
      _customerSeleccionado = null;
      _controller.clear();
    });

    widget.onChanged(null);

    _focusNode.unfocus();

    _limpiando = false;
  }

  @override
  void didUpdateWidget(covariant CustomerSelect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue && _customerSeleccionado == null) {
      _aplicarValorInicial(widget.initialValue);
    }
  }

  void _aplicarValorInicial(Customer? socio) {
    if (socio == null) return;
    _customerSeleccionado = socio;
    _controller.text = socio.fullName;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return RawAutocomplete<Customer>(
          textEditingController: _controller,
          focusNode: _focusNode,

          displayStringForOption: (socio) => socio.fullName,

          optionsBuilder: (value) {
            if (_limpiando || _customerSeleccionado != null) {
              return const Iterable<Customer>.empty();
            }

            final query = value.text.toLowerCase().trim();

            if (query.isEmpty) {
              return widget.customers;
            }

            return widget.customers.where((socio) {
              return socio.fullName.toLowerCase().contains(query) ||
                  socio.documentNumber.contains(query);
            });
          },

          onSelected: (socio) {
            setState(() {
              _customerSeleccionado = socio;
            });

            widget.onChanged(socio);
            _focusNode.unfocus();
          },

          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              readOnly: _customerSeleccionado != null,
              textAlignVertical: TextAlignVertical.center,

              onChanged: (_) {
                // Si se edita el texto, invalidar
                // cualquier selección anterior.
                if (_customerSeleccionado != null) {
                  setState(() {
                    _customerSeleccionado = null;
                  });
                  widget.onChanged(null);
                }
              },

              decoration: InputDecoration(
                hintText: 'Buscar cliente por nombre o documento',

                hintStyle: const TextStyle(color: AppColors.primary, fontSize: 14),

                prefixIcon: const Icon(Icons.search, color: AppColors.textPrimary),

                suffixIcon: _customerSeleccionado != null
                    ? IconButton(
                        tooltip: 'Quitar cliente seleccionado',
                        icon: const Icon(Icons.close, color: AppColors.textPrimary),
                        onPressed: _limpiarSeleccion,
                      )
                    : IconButton(
                        tooltip: 'Buscar cliente',
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.textPrimary,
                        ),
                        onPressed: () {
                          focusNode.requestFocus();
                        },
                      ),

                filled: true,
                fillColor: Colors.white,

                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

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
            );
          },

          optionsViewBuilder: (context, onOptionSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 6,
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),

                child: SizedBox(
                  width: constraints.maxWidth,

                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 260),

                    child: ListView.builder(
                      padding: const EdgeInsets.all(6),
                      shrinkWrap: true,
                      itemCount: options.length,

                      itemBuilder: (context, index) {
                        final socio = options.elementAt(index);

                        return ListTile(
                          onTap: () {
                            onOptionSelected(socio);
                          },

                          leading: CircleAvatar(
                            backgroundColor: AppColors.info,

                            child: Text(
                              socio.fullName[0].toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          title: Text(
                            socio.fullName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryDark,
                            ),
                          ),

                          subtitle: Text(
                            'DNI: ${socio.documentNumber}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
