import 'package:flutter_audio_mix/models/media.dart';

class SoundModel {
  SoundModel({this.title, this.media, this.id, this.isPlaying = false});

  String? title;
  String? id;
  Media? media;
  bool isPlaying;

  factory SoundModel.fromJson(Map<String, dynamic> json) => SoundModel(
        title: json["title"],
        id: json["id"],
        media: json["media"] == null ? null : Media.fromJson(json["media"]),
      );

  Map<String, dynamic> toJson() =>
      {"title": title, "id": id, "media": media?.toJson()};
}
