///
///
/// TODO - Criar classe abstrata para manter o padrão da validação.
class CepValidator {
  static const String STRIP_REGEX = r'[^\d]';

  ///
  ///
  ///
  static String format(String cep) {
    RegExp regExp = RegExp(r'^(\d{2})(\d{3})(\d{3})$');

    return strip(cep)
        .replaceAllMapped(regExp, (Match m) => '${m[1]}.${m[2]}-${m[3]}');
  }

  ///
  ///
  ///
  static String strip(String cep) {
    RegExp regex = RegExp(STRIP_REGEX);
    cep = cep ?? '';

    return cep.replaceAll(regex, '');
  }

  ///
  ///
  ///
  static bool isValid(String cep, [bool stripBeforeValidation = true]) {
    if (stripBeforeValidation) {
      cep = strip(cep);
    }

    if (cep == null || cep.isEmpty) {
      return false;
    }

    if (cep.length != 8) {
      return false;
    }

    return true;
  }
}
