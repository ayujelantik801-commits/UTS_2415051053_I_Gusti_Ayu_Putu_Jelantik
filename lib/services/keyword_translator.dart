/// Menerjemahkan kata kunci pencarian Indonesia ke Inggris,
/// karena TheMealDB hanya memahami bahasa Inggris.
class KeywordTranslator {
  static const _dictionary = {
    'kue': 'cake',
    'kue kering': 'cookie',
    'roti': 'bread',
    'pai': 'pie',
    'cokelat': 'chocolate',
    'coklat': 'chocolate',
    'keju': 'cheese',
    'pisang': 'banana',
    'apel': 'apple',
    'jeruk': 'orange',
    'stroberi': 'strawberry',
    'kelapa': 'coconut',
    'wortel': 'carrot',
    'labu': 'pumpkin',
    'madu': 'honey',
    'kacang': 'nut',
    'mentega': 'butter',
    'telur': 'egg',
  };

  static String toEnglish(String input) {
    final text = input.trim().toLowerCase();
    if (_dictionary.containsKey(text)) return _dictionary[text]!;
    return text
        .split(RegExp(r'\s+'))
        .map((word) => _dictionary[word] ?? word)
        .join(' ');
  }
}