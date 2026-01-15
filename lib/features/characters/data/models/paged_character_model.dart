import 'character_model.dart';

class PagedCharacterModel {

  final int count;
  final int pages;
  final String? next;
  final String? prev;
  final List<CharacterModel> results;
  
  const PagedCharacterModel({
    required this.count,
    required this.pages,
    required this.next,
    required this.prev,
    required this.results,
  });

  factory PagedCharacterModel.fromJson(Map<String, dynamic> json) {
    final info = (json['info'] ?? {}) as Map<String, dynamic>;
    final resultsJson = (json['results'] ?? []) as List<dynamic>;

    return PagedCharacterModel(
      count: (info['count'] ?? 0) as int,
      pages: (info['pages'] ?? 0) as int,
      next: info['next'] as String?,
      prev: info['prev'] as String?,
      results: resultsJson
          .map((e) => CharacterModel.fromJson(e as Map<String, dynamic>))
          .toList()
    );
  }

}