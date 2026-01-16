import '../../domain/entities/character.dart';

class FavoriteCharacterModel {
  final int id;
  final String name;
  final String image;
  final String species;
  final String gender;
  final String origin;
  final String location;
  final int createdAt;

  const FavoriteCharacterModel({
    required this.id,
    required this.name,
    required this.image,
    required this.species,
    required this.gender,
    required this.origin,
    required this.location,
    required this.createdAt,
  });

  factory FavoriteCharacterModel.fromEntity(Character c) {
    return FavoriteCharacterModel(
      id: c.id,
      name: c.name,
      image: c.image,
      species: c.species,
      gender: c.gender,
      origin: c.origin,
      location: c.location,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'image': image,
        'species': species,
        'gender': gender,
        'origin': origin,
        'location': location,
        'created_at': createdAt,
      };

  factory FavoriteCharacterModel.fromMap(Map<String, Object?> map) {
    return FavoriteCharacterModel(
      id: map['id'] as int,
      name: map['name'] as String,
      image: map['image'] as String,
      species: map['species'] as String,
      gender: map['gender'] as String,
      origin: map['origin'] as String,
      location: map['location'] as String,
      createdAt: map['created_at'] as int,
    );
  }

  Character toEntity() => Character(
        id: id,
        name: name,
        species: species,
        gender: gender,
        origin: origin,
        location: location,
        image: image,
      );
}
