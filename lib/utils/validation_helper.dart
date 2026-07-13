/// Utilitário de validação
class ValidationHelper {
  /// Valida nome
  static bool isValidName(String name) {
    return name.isNotEmpty && name.length >= 2 && name.length <= 100;
  }

  /// Valida número
  static bool isValidNumber(String? number) {
    if (number == null || number.isEmpty) return true;
    return number.length <= 10;
  }

  /// Valida nome de competição
  static bool isValidCompetitionName(String name) {
    return name.isNotEmpty && name.length >= 3 && name.length <= 100;
  }

  /// Retorna mensagem de erro
  static String getNameErrorMessage(String name) {
    if (name.isEmpty) {
      return 'O nome não pode estar vazio';
    }
    if (name.length < 2) {
      return 'O nome deve ter no mínimo 2 caracteres';
    }
    if (name.length > 100) {
      return 'O nome pode ter no máximo 100 caracteres';
    }
    return '';
  }
}
