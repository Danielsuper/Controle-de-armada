/// Utilitário de formatação de datas
class DateFormatHelper {
  /// Formata data no padrão brasileiro
  static String formatDate(DateTime date) {
    return '${_padZero(date.day)}/${_padZero(date.month)}/${date.year}';
  }

  /// Formata data e hora no padrão brasileiro
  static String formatDateTime(DateTime dateTime) {
    return '${formatDate(dateTime.toLocal())} ${_padZero(dateTime.hour)}:${_padZero(dateTime.minute)}';
  }

  /// Retorna data relativa (ex: "Há 2 horas")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Há alguns segundos';
    } else if (difference.inMinutes < 60) {
      return 'Há ${difference.inMinutes} minuto(s)';
    } else if (difference.inHours < 24) {
      return 'Há ${difference.inHours} hora(s)';
    } else if (difference.inDays < 7) {
      return 'Há ${difference.inDays} dia(s)';
    } else {
      return formatDate(dateTime);
    }
  }

  /// Padding de zeros
  static String _padZero(int value) {
    return value.toString().padLeft(2, '0');
  }
}
