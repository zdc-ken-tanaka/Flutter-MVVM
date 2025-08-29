import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'media.dart';

class FavoriteRepository {
  static const String _favoriteKey = 'favorite_media_list';

  Future<List<Media>> getFavoriteList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteJson = prefs.getString(_favoriteKey);
      
      if (favoriteJson == null) {
        return [];
      }

      final List<dynamic> decoded = jsonDecode(favoriteJson);
      return decoded.map((json) => Media.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> addToFavorites(Media media) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteList = await getFavoriteList();
      
      if (!favoriteList.any((item) => item.trackId == media.trackId)) {
        favoriteList.add(media.copyWith(isFavorite: true));
        final jsonString = jsonEncode(favoriteList.map((e) => _mediaToJson(e)).toList());
        return await prefs.setString(_favoriteKey, jsonString);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFromFavorites(int trackId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteList = await getFavoriteList();
      
      favoriteList.removeWhere((media) => media.trackId == trackId);
      final jsonString = jsonEncode(favoriteList.map((e) => _mediaToJson(e)).toList());
      return await prefs.setString(_favoriteKey, jsonString);
    } catch (e) {
      return false;
    }
  }

  Future<bool> isFavorite(int trackId) async {
    final favoriteList = await getFavoriteList();
    return favoriteList.any((media) => media.trackId == trackId);
  }

  Map<String, dynamic> _mediaToJson(Media media) {
    return {
      'trackId': media.trackId,
      'artistName': media.artistName,
      'collectionName': media.collectionName,
      'trackName': media.trackName,
      'artworkUrl100': media.artworkUrl,
      'previewUrl': media.previewUrl,
    };
  }
}