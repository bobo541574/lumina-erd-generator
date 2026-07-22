class StringUtils {
  StringUtils._();

  static String camelCase(String input) {
    if (input.isEmpty) return input;
    final words = input.split(RegExp(r'[_\- ]+'));
    if (words.isEmpty) return input;
    return words[0].toLowerCase() +
        words.skip(1).map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase()).join();
  }

  static String snakeCase(String input) {
    if (input.isEmpty) return input;
    final buffer = StringBuffer();
    for (var i = 0; i < input.length; i++) {
      final char = input[i];
      if (char == char.toUpperCase() && char != char.toLowerCase()) {
        if (i > 0) buffer.write('_');
        buffer.write(char.toLowerCase());
      } else {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }

  static String pluralize(String word) {
    if (word.isEmpty) return word;
    if (word.endsWith('y') && !_isVowel(word[word.length - 2])) {
      return '${word.substring(0, word.length - 1)}ies';
    }
    if (word.endsWith('s') || word.endsWith('sh') || word.endsWith('ch') ||
        word.endsWith('x') || word.endsWith('z')) {
      return '${word}es';
    }
    return '${word}s';
  }

  static String singularize(String word) {
    if (word.isEmpty) return word;
    if (word.endsWith('ies')) {
      return '${word.substring(0, word.length - 3)}y';
    }
    if (word.endsWith('ses') || word.endsWith('shes') || word.endsWith('ches') ||
        word.endsWith('xes') || word.endsWith('zes')) {
      return word.substring(0, word.length - 2);
    }
    if (word.endsWith('s') && !word.endsWith('ss')) {
      return word.substring(0, word.length - 1);
    }
    return word;
  }

  static String modelToTableName(String modelName) {
    final snake = snakeCase(modelName);
    return pluralize(snake);
  }

  static bool _isVowel(String char) {
    return 'aeiou'.contains(char.toLowerCase());
  }

  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}
