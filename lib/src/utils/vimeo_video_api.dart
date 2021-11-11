import 'dart:convert';
import 'dart:developer';

import 'package:fl_video_player/src/controllers/fl_getx_video_controller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'vimeo_models.dart';

String flErrorString(String val) {
  return '*\n------error------\n\n$val\n\n------end------\n*';
}

class VimeoVideoApi {
  static Future<List<VimeoVideoQalityUrls>?> getvideoQualityLink(
    String videoId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('https://player.vimeo.com/video/$videoId/config'),
      );
      final jsonData =
          jsonDecode(response.body)['request']['files']['progressive'];
      return List.generate(
          jsonData.length,
          (index) => VimeoVideoQalityUrls(
                quality: int.parse(
                    (jsonData[index]['quality'] as String?)?.split('p').first ??
                        '0'),
                urls: jsonData[index]['url'],
              ));
    } catch (error) {
      if (error.toString().contains('XMLHttpRequest')) {
        log(flErrorString('(INFO) Please enable CORS in your browser'));
        print(
            'ERROR REFERENCE:\nEnable this plugin: https://chrome.google.com/webstore/detail/allow-cors-access-control/lhobafahddgcelffkeicbaginigeejlf?hl=en');
      }
      debugPrint('===== VIMEO API ERROR: $error ==========');
      return null;
    }
  }
}
