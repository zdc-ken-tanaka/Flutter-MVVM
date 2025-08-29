import 'package:flutter/cupertino.dart';
import 'package:mvvm_flutter_app/model/apis/api_response.dart';
import 'package:mvvm_flutter_app/model/media.dart';
import 'package:mvvm_flutter_app/model/media_repository.dart';
import 'package:mvvm_flutter_app/model/favorite_repository.dart';

class MediaViewModel with ChangeNotifier {
  ApiResponse _apiResponse = ApiResponse.initial('Empty data');
  ApiResponse _favoriteApiResponse = ApiResponse.initial('Empty data');

  Media? _media;
  final FavoriteRepository _favoriteRepository = FavoriteRepository();

  ApiResponse get response {
    return _apiResponse;
  }

  ApiResponse get favoriteResponse {
    return _favoriteApiResponse;
  }

  Media? get media {
    return _media;
  }

  /// Call the media service and gets the data of requested media data of
  /// an artist.
  Future<void> fetchMediaData(String value) async {
    _apiResponse = ApiResponse.loading('Fetching artist data');
    notifyListeners();
    try {
      List<Media> mediaList = await MediaRepository().fetchMediaList(value);
      _apiResponse = ApiResponse.completed(mediaList);
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  void setSelectedMedia(Media? media) {
    _media = media;
    notifyListeners();
  }

  /// お気に入りリストを取得する
  Future<void> fetchFavoriteList() async {
    _favoriteApiResponse = ApiResponse.loading('Loading favorites');
    notifyListeners();
    try {
      List<Media> favoriteList = await _favoriteRepository.getFavoriteList();
      _favoriteApiResponse = ApiResponse.completed(favoriteList);
    } catch (e) {
      _favoriteApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  /// お気に入りに追加
  Future<void> addToFavorites(Media media) async {
    try {
      bool success = await _favoriteRepository.addToFavorites(media);
      if (success) {
        await _updateMediaListWithFavoriteStatus();
        notifyListeners();
      }
    } catch (e) {
      print('Failed to add to favorites: $e');
    }
  }

  /// お気に入りから削除
  Future<void> removeFromFavorites(int trackId) async {
    try {
      bool success = await _favoriteRepository.removeFromFavorites(trackId);
      if (success) {
        await _updateMediaListWithFavoriteStatus();
        await fetchFavoriteList();
        notifyListeners();
      }
    } catch (e) {
      print('Failed to remove from favorites: $e');
    }
  }

  /// お気に入り状態を確認
  Future<bool> isFavorite(int trackId) async {
    return await _favoriteRepository.isFavorite(trackId);
  }

  /// メディアリストのお気に入り状態を更新
  Future<void> _updateMediaListWithFavoriteStatus() async {
    if (_apiResponse.data is List<Media>) {
      List<Media> mediaList = _apiResponse.data as List<Media>;
      List<Media> updatedList = [];
      
      for (Media media in mediaList) {
        if (media.trackId != null) {
          bool isFav = await _favoriteRepository.isFavorite(media.trackId!);
          updatedList.add(media.copyWith(isFavorite: isFav));
        } else {
          updatedList.add(media);
        }
      }
      
      _apiResponse = ApiResponse.completed(updatedList);
    }
  }
}
