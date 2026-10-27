import 'package:flutter/material.dart';

/// Paleta de colores de NovaSys Minimarket.
/// Extraída de los mockups (Login, Dashboard, POS, Cobro, Inventario, etc.).
abstract final class AppColors {
  // ───────────────────────── Marca ─────────────────────────
  /// Azul principal: botones "Ingresar", "Agregar al carrito", tab activo, card POS.
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primarySoft = Color(0xFFDBEAFE); // fondos de chips / método seleccionado
  static const Color primarySurface = Color(0xFFEFF4FF); // caja "Total a pagar"

  /// Violeta secundario: card "Escanear código de barras", logo.
  static const Color secondary = Color(0xFF7C3AED);
  static const Color secondaryLight = Color(0xFF8B5CF6);
  static const Color secondarySoft = Color(0xFFEDE9FE);

  // ───────────────────────── Estados ─────────────────────────
  /// Verde: "Cobrar", "Confirmar pago", "Caja abierta", entradas, stock normal.
  static const Color success = Color(0xFF16A34A);
  static const Color successDark = Color(0xFF15803D);
  static const Color successSoft = Color(0xFFDCFCE7);

  /// Rojo: stock bajo, salidas, eliminar ítem, cerrar sesión.
  static const Color danger = Color(0xFFDC2626);
  static const Color dangerLight = Color(0xFFEF4444);
  static const Color dangerSoft = Color(0xFFFEE2E2);

  /// Ámbar: vuelto, advertencias.
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningSoft = Color(0xFFFEF3C7);

  /// Azul info: transferencias entre almacenes.
  static const Color info = Color(0xFF2563EB);
  static const Color infoSoft = Color(0xFFDBEAFE);

  // ───────────────────────── Métodos de pago ─────────────────────────
  static const Color efectivo = success;
  static const Color efectivoSoft = successSoft;
  static const Color yapePlin = Color(0xFF7C3AED);
  static const Color yapePlinSoft = Color(0xFFEDE9FE);
  static const Color tarjeta = primary;
  static const Color tarjetaSoft = primarySoft;

  // ───────────────────────── Neutros / superficies ─────────────────────────
  static const Color background = Color(0xFFF5F7FB); // fondo de pantallas
  static const Color surface = Color(0xFFFFFFFF); // cards, app bar, bottom nav
  static const Color surfaceVariant = Color(0xFFF1F5F9); // inputs, chips inactivos
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFEEF2F6);

  // ───────────────────────── Texto ─────────────────────────
  static const Color textPrimary = Color(0xFF0F172A); // títulos, precios
  static const Color textSecondary = Color(0xFF64748B); // subtítulos, horas
  static const Color textHint = Color(0xFF94A3B8); // placeholders
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ───────────────────────── Escáner ─────────────────────────
  static const Color scannerOverlay = Color(0xFF0F172A);
  static const Color scannerPanel = Color(0xFF1E293B);
  static const Color scannerLaser = Color(0xFFEF4444);
  static const Color scannerFrame = Color(0xFFFFFFFF);

  // ───────────────────────── Navegación ─────────────────────────
  static const Color navActive = primary;
  static const Color navInactive = Color(0xFF94A3B8);

  // ───────────────────────── Gradientes ─────────────────────────
  static const LinearGradient loginBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0xFFE8EFFD)],
  );

  static const LinearGradient primaryCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary],
  );

  static const LinearGradient secondaryCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryLight, secondary],
  );
}

/// Helpers para chips de estado (método de pago, movimiento, stock).
enum ChipTone { success, danger, info, secondary, warning }

extension ChipToneColors on ChipTone {
  Color get foreground => switch (this) {
    ChipTone.success => AppColors.successDark,
    ChipTone.danger => AppColors.danger,
    ChipTone.info => AppColors.primary,
    ChipTone.secondary => AppColors.secondary,
    ChipTone.warning => const Color(0xFFB45309),
  };

  Color get background => switch (this) {
    ChipTone.success => AppColors.successSoft,
    ChipTone.danger => AppColors.dangerSoft,
    ChipTone.info => AppColors.primarySoft,
    ChipTone.secondary => AppColors.secondarySoft,
    ChipTone.warning => AppColors.warningSoft,
  };
}

class AppShadow {
  static const soft = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 12,
    offset: Offset(0, 4),
  );
}
