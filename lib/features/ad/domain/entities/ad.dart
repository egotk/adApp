import 'package:actonica/features/auth/domain/entities/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Ad {
  final String id;
  final String name;
  final String? description;
  final String category;
  final AppUser appUser;
  final DateTime timestamp;
  final String? imageUrl;
  final double? price;
  final List<String> favouritedByPhoneNumbers;

  Ad({
    String? id,
    required this.name,
    this.description,
    required this.category,
    required this.appUser,
    DateTime? timestamp,
    this.imageUrl,
    this.price,
    List<String>? favouritedByPhoneNumbers,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now(),
        favouritedByPhoneNumbers = favouritedByPhoneNumbers ?? [];

  static final _dateFormatter = DateFormat("dd.MM.yyyy");
  get dateFormatter => _dateFormatter;

  // ad -> json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'user': appUser.toJson(),
      'timestamp': Timestamp.fromDate(timestamp),
      'imageUrl': imageUrl,
      'price': price,
      'favouritedByPhoneNumbers': favouritedByPhoneNumbers,
    };
  }

  Ad copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    AppUser? appUser,
    DateTime? timestamp,
    String? imageUrl,
    double? price,
    List<String>? favouritedByPhoneNumbers,
  }) {
    return Ad(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      appUser: appUser ?? this.appUser,
      timestamp: timestamp ?? this.timestamp,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      favouritedByPhoneNumbers:
          favouritedByPhoneNumbers ?? this.favouritedByPhoneNumbers,
    );
  }

  // json -> ad
  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      appUser: AppUser.fromJson(json['user']),
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      imageUrl: json['imageUrl'],
      price: json['price'],
      favouritedByPhoneNumbers: List.from(json['favouritedByPhoneNumbers']),
    );
  }
}
