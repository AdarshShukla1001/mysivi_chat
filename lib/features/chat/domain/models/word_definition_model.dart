class WordDefinitionModel {
  final String word;
  final String? phonetic;
  final List<Meaning> meanings;

  WordDefinitionModel({
    required this.word,
    this.phonetic,
    required this.meanings,
  });

  factory WordDefinitionModel.fromJson(Map<String, dynamic> json) {
    return WordDefinitionModel(
      word: json['word'] ?? '',
      phonetic: json['phonetic'],
      meanings:
          (json['meanings'] as List?)
              ?.map((e) => Meaning.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Meaning {
  final String partOfSpeech;
  final List<Definition> definitions;

  Meaning({required this.partOfSpeech, required this.definitions});

  factory Meaning.fromJson(Map<String, dynamic> json) {
    return Meaning(
      partOfSpeech: json['partOfSpeech'] ?? '',
      definitions:
          (json['definitions'] as List?)
              ?.map((e) => Definition.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Definition {
  final String definition;
  final String? example;

  Definition({required this.definition, this.example});

  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition(
      definition: json['definition'] ?? '',
      example: json['example'],
    );
  }
}
