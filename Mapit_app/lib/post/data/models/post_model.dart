import 'package:equatable/equatable.dart';

class PostModel extends Equatable {
  final String? postId;
  final String? userId;
  final double lat;
  final double lng;
  final String? createdAt;
  String? content;
  String? image;
  String? title;
  String updatedAt;
  bool? private;
  PostModel({
    this.private,
    required this.postId,
    this.title,
    required this.lat,
    required this.lng,
    this.createdAt,
    required this.userId,
    String? updatedAt,
    this.image,
    this.content,
  }) : updatedAt = updatedAt ?? createdAt!;

  Map<String, dynamic> toJson() {
    return {
      'places_id': postId,
      'latitud': lat,
      'longitude': lng,
      'post_text': content,
      'url_post_photo': image,
      'user_id': userId,
      'post_title': title,
      'private': false,
    };
  }

  @override
  List<Object?> get props => [
        postId,
        userId,
        content,
        image,
        title,
        createdAt,
        updatedAt,
        lat,
        lng,
        private
      ];
  void dispose() {
    // Realiza cualquier limpieza de recursos aquí, si es necesario
    // Por ejemplo, cerrar archivos, cancelar suscripciones, etc.
  }
}
