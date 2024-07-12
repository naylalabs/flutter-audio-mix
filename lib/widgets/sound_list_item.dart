import 'package:flutter/material.dart';
import 'package:flutter_audio_mix/utils/assets.dart';

import 'default_circular_button.dart';

class SoundListItem extends StatelessWidget {
  const SoundListItem({
    super.key,
    required this.size,
    this.title,
    this.backgroundImage,
    this.onPressed,
    this.isPlaying,
  });

  final Size size;
  final String? title;
  final String? backgroundImage;
  final bool? isPlaying;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Column(
          children: [
            Container(
              height: size.width * 0.18,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "$title",
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800),
                  ),
                  DefaultCircularButton(
                      iconSize: 48,
                      assetName:
                          isPlaying ?? false ? Assets.icStop : Assets.icPlay,
                      innerIconSize: 32,
                      iconColor: Colors.white,
                      press: onPressed),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
