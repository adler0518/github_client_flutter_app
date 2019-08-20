import 'package:flutter/material.dart';
import '../l10n/index.dart';
import '../models/index.dart';
import '../common/ShareModel.dart';
import 'package:provider/provider.dart';
import '../l10n/MyLocalizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart';
import '../common/Network.dart';
import 'package:github_client_app/widgets/RepoItem.dart';
import 'package:github_client_app/widgets/MyDrawer.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() {
    return _HomeRouteState();
  }
}

class _HomeRouteState extends State<HomeRoute> {
  int _page = 1;
  final _pageSize = 5;
  bool _showPullUp = true;
  List<Repo> items = [];
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  void _onRefresh() async{
    var data = await Git(context).getRepos(
      refresh: true,
      queryParameters: {
        'page': 1,
        'per_page': _pageSize,
      },
    );

    print('refresh : ${data.length}');

    if (data != null) {
      _page = 1;

      //Add data to items.
      items.removeRange(0, items.length);
      items.addAll(data);

      setState(() {});

      if (data.length == _pageSize) {
        _showPullUp = true;
      }else {
        _showPullUp = false;
      }
    }

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    var data = await Git(context).getRepos(
      refresh: true,
      queryParameters: {
        'page': _page+1,
        'per_page': _pageSize,
      },
    );

    print('load more: ${data.length}');

    if(data.length > 0) {
      //Add data to items.
      items.addAll(data);
      setState(() {});

      _page += 1;

      if (data.length == _pageSize) {
        _showPullUp = true;
      }else {
        _showPullUp = false;
      }
    }else if(data != null) {
      _showPullUp = false;
    }

    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyLocalizations.of(context).home("Git")),
      ),
      body: _buildBody(),
      drawer: MyDrawer(),
    );
  }

  Widget _buildBody() {
    UserModel userModel = Provider.of<UserModel>(context);

    //Show login button when is not log in.
    if (!userModel.isLogin) {
      return Center(
        child: RaisedButton(
            child: Text(MyLocalizations.of(context).login()),
            onPressed: () => Navigator.of(context).pushNamed('login')),
      );
    } else {
      return SmartRefresher(
        enablePullDown: true,
        enablePullUp: _showPullUp,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("上拉加载");
            }
            else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            }
            else if (mode == LoadStatus.failed) {
              body = Text("加载失败！点击重试！");
            }
            else {
              body = Text("没有更多数据了!");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
          itemBuilder: (c, i) => RepoItem(items[i]),
//          itemExtent: 100.0,
          itemCount: items.length,
        ),
      );
    }
  }
}