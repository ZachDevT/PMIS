// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Testimonial {
  final String image;
  final String name;
  final String quote;
  final String videoUrl;
  final String location;

  Testimonial({
    required this.videoUrl,  // Video URL is optional, so it's marked as nullable.
    required this.image,
    required this.name,
    required this.quote,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image': image,
      'name': name,
      'quote': quote,
      'location': location,
      'videoUrl': videoUrl,
    };
  }

  factory Testimonial.fromMap(Map<String, dynamic> map) {
    return Testimonial(
      videoUrl: map['videoUrl'] as String,
      image: map['image'] as String,
      name: map['name'] as String,
      quote: map['quote'] as String,
      location: map['location'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Testimonial.fromJson(String source) =>
      Testimonial.fromMap(json.decode(source) as Map<String, dynamic>);
}
