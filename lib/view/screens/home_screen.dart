import 'package:flutter/material.dart';
import 'package:mvvm_flutter_app/model/apis/api_response.dart';
import 'package:mvvm_flutter_app/model/media.dart';
import 'package:mvvm_flutter_app/view/widgets/player_list_widget.dart';
import 'package:mvvm_flutter_app/view/widgets/player_widget.dart';
import 'package:mvvm_flutter_app/view/screens/favorite_screen.dart';
import 'package:mvvm_flutter_app/view_model/media_view_model.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  Widget getMediaWidget(BuildContext context, ApiResponse apiResponse) {
    List<Media>? mediaList = apiResponse.data as List<Media>?;
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 8,
              child: PlayerListWidget(mediaList!, (Media media) {
                Provider.of<MediaViewModel>(context, listen: false)
                .setSelectedMedia(media);
              }),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: PlayerWidget(
                  function: () {
                    setState(() {});
                  },
                ),
              ),
            ),
          ],
        );
      case Status.ERROR:
        return Center(
          child: Text('Please try again latter!!!'),
        );
      case Status.INITIAL:
      default:
        return Center(
          child: Text('Search the song by Artist'),
        );
    }
  }

  Widget _buildSearchTab() {
    final _inputController = TextEditingController();
    ApiResponse apiResponse = Provider.of<MediaViewModel>(context).response;
    
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor.withAlpha(50),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: TextField(
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                      controller: _inputController,
                      onChanged: (value) {},
                      onSubmitted: (value) async {
                        if (value.isNotEmpty) {
                          Provider.of<MediaViewModel>(context, listen: false)
                              .setSelectedMedia(null);
                          await Provider.of<MediaViewModel>(context, listen: false)
                              .fetchMediaData(value);
                        }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        hintText: 'Enter Artist Name',
                      )),
                ),
              ),
            ],
          ),
        ),
        Expanded(child: getMediaWidget(context, apiResponse)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Media Player'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.search), text: '検索'),
            Tab(icon: Icon(Icons.favorite), text: 'お気に入り'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSearchTab(),
                FavoriteScreen(),
              ],
            ),
          ),
          Consumer<MediaViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.media != null) {
                return Container(
                  height: 80,
                  child: PlayerWidget(
                    function: () {
                      setState(() {});
                    },
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
