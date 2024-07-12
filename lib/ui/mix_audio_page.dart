import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_audio_mix/main.dart';
import 'package:flutter_audio_mix/models/sound_model.dart';
import 'package:flutter_audio_mix/models/sounds_response.dart';
import 'package:flutter_audio_mix/utils/constants.dart';
import 'package:flutter_audio_mix/widgets/sound_list_item.dart';
import 'package:http/http.dart' as http;

class MixAudioPage extends StatefulWidget {
  const MixAudioPage({super.key});

  @override
  State<MixAudioPage> createState() => _MixAudioPageState();
}

class _MixAudioPageState extends State<MixAudioPage> {
  late Size size;
  late Future<SoundsResponse> _futureSounds;
  List<SoundModel> soundList = [];

  // for update list view without setState
  ValueNotifier<bool> mediaPlayerState = ValueNotifier(false);
  ValueNotifier<bool> isPlaying = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _futureSounds = fetchSounds();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: InkWell(
              onTap: () {
                fetchSounds();
              },
              child: const Text("Audio mix sample")),
        ),
        body: _buildUI(),
        bottomNavigationBar: _buildMusicPlayer());
  }

  Future<SoundsResponse> fetchSounds() async {
    final response = await http.get(Uri.parse(Constants.apiBaseUrl));

    if (response.statusCode == 200) {
      var value = jsonDecode(response.body);
      debugPrint(value);
      return SoundsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  buildErrorBody(String error) {
    return Column(
      children: [
        const Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 60,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text('Error: $error'),
        )
      ],
    );
  }

  _buildUI() {
    return SafeArea(
      child: FutureBuilder<SoundsResponse>(
        future: _futureSounds,
        builder:
            (BuildContext context, AsyncSnapshot<SoundsResponse> snapshot) {
          if (snapshot.hasData) {
            soundList = snapshot.data?.data ?? [];
            return _buildBody();
          } else if (snapshot.hasError) {
            return buildErrorBody(snapshot.error.toString());
          } else {
            return const Center(
              child: SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  void lisStateChange() {
    mediaPlayerState.value = !mediaPlayerState.value;
    //for music player
    isPlaying.value = !isPlaying.value;
  }

  play(SoundModel model) async {
    if (model.isPlaying) {
      model.isPlaying = false;
      audioHandler.customAction("pause", {"id": model.id});
    } else {
      model.isPlaying = true;
      audioHandler
          .customAction("mixMusic", {"url": model.media!.url, "id": model.id});
    }
    lisStateChange();
  }

  Widget _buildBody() {
    return ValueListenableBuilder(
      valueListenable: mediaPlayerState,
      builder: (BuildContext context, dynamic value, Widget? child) {
        return ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: soundList.length,
            shrinkWrap: true,
            addAutomaticKeepAlives: true,
            itemBuilder: (context, index) {
              SoundModel model = soundList[index];
              return SoundListItem(
                  title: model.title,
                  backgroundImage: model.media!.artUri.toString(),
                  size: size,
                  isPlaying: model.isPlaying,
                  onPressed: () {
                    play(model);
                  });
            });
      },
    );
  }

  _buildMusicPlayer() {
    return ValueListenableBuilder(
        valueListenable: isPlaying,
        builder: (BuildContext context, bool isPlaying, Widget? child) {
          return Stack(
            children: [
              Container(
                color: Colors.black,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          soundList
                              .where((e) => e.isPlaying)
                              .map((e) => "${e.title}")
                              .toString(),
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(width: 8),
                        /*     DefaultCircularButton(
                          iconSize: 48,
                          assetName:
                              isPlaying ? Assets.ic_stop : Assets.ic_play,
                          iconColor: Colors.white,
                          innerIconSize: 32,
                          press: () async {
                            if (isPlaying) {
                              audioHandler.pause();
                            } else {
                              audioHandler.play();
                            }
                            // lisStateChange();
                          },
                        ),*/
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  ElevatedButton startButton(String label, VoidCallback onPressed) =>
      ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      );

  IconButton playButton() => IconButton(
        icon: const Icon(Icons.play_arrow),
        iconSize: 64.0,
        onPressed: () {
          audioHandler.play();
        },
      );

  IconButton stopButton() => IconButton(
        icon: const Icon(Icons.stop),
        iconSize: 64.0,
        onPressed: () {
          audioHandler.customAction("pause", {});
        },
      );
}
