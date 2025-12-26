import '../../features/chat/domain/models/word_definition_model.dart';

abstract class DictionaryService {
  Future<WordDefinitionModel?> fetchDefinition(String word);
}
