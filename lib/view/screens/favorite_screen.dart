import 'package:flutter/material.dart';
import 'package:mvvm_flutter_app/model/apis/api_response.dart';
import 'package:mvvm_flutter_app/model/media.dart';
import 'package:mvvm_flutter_app/view/widgets/player_list_widget.dart';
import 'package:mvvm_flutter_app/view_model/media_view_model.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    final mediaViewModel = Provider.of<MediaViewModel>(context, listen: false);
    mediaViewModel.fetchFavoriteList();
  }

  @override
  Widget build(BuildContext context) {
    ApiResponse apiResponse = Provider.of<MediaViewModel>(context).favoriteResponse;
    return getViewBasedOnState(apiResponse);
  }

  Widget getViewBasedOnState(ApiResponse apiResponse) {
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        return _renderSuccessView(apiResponse.data as List<Media>);
      case Status.ERROR:
        return Center(
          child: Text('エラーが発生しました'),
        );
      case Status.INITIAL:
      default:
        return Center(
          child: Text('お気に入りリストを読み込み中...'),
        );
    }
  }

  Widget _renderSuccessView(List<Media> mediaList) {
    if (mediaList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'お気に入りの楽曲がありません',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '楽曲リストでハートアイコンをタップして\nお気に入りに追加しましょう',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: <Widget>[
        Container(
          height: 55,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.favorite,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'お気に入り (${mediaList.length}曲)',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: PlayerListWidget(mediaList, (Media media) {
            Provider.of<MediaViewModel>(context, listen: false)
                .setSelectedMedia(media);
          }),
        ),
      ],
    );
  }
}