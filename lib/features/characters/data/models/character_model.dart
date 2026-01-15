import '../../domain/entities/character.dart';

class CharacterModel {
  final int id;
  final String name;
  final String species;
  final String gender;
  final String origin;
  final String location;
  final String image;

  const CharacterModel({
    required this.id,
    required this.name,
    required this.species,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] as int,
      name: (json['name'] ?? '') as String,
      species: (json['species'] ?? '') as String,
      gender: (json['gender'] ?? '') as String,
      origin: (json['origin']['name'] ?? '') as String,
      location: (json['location']['name'] ?? '') as String,
      image: (json['image'] ?? '') as String,
    );
  }
}

extension CharacterModelMapper on CharacterModel {
  Character toEntity() {
    return Character(
      id: id,
      name: name,
      species: species,
      gender: gender,
      origin: origin,
      location: location,
      image: image,
    );
  }
}