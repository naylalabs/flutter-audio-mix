

import 'package:flutter_audio_mix/models/sound_model.dart';

class SoundsResponse  {
  SoundsResponse({
    this.data,
  });

  List<SoundModel>? data;

  factory SoundsResponse.fromJson(Map<String, dynamic> json) => SoundsResponse(
    data: json["soundList"] == null
        ? null
        : List<SoundModel>.from(
        json["soundList"].map((x) => SoundModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "soundList": data == null
        ? null
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}
