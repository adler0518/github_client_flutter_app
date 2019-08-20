import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:github_client_flutter_app/common/ShareModel.dart';
import 'package:github_client_flutter_app/l10n/MyLocalizations.dart';
import 'package:github_client_flutter_app/common/gmAvatar.dart';


class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      //移除顶部padding
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(), //构建抽屉菜单头部
            Expanded(child: _buildMenus()), //构建功能菜单
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<UserModel>(
      builder: (BuildContext context, UserModel value, Widget child) {
        return GestureDetector(
          child: Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.only(top: 40, bottom: 20),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ClipOval(
                    // 如果已登录，则显示用户头像；若未登录，则显示默认头像
                    child: value.isLogin
                        ? gmAvatar(value.user.avatar_url, width: 80)
                        : Image.asset("imgs/qqbg.jpg", width: 80,),
                  ),
                ),
                Text(
                  value.isLogin ? value.user.login : MyLocalizations.of(context).login(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          onTap: () {
            if (!value.isLogin) Navigator.of(context).pushNamed("login");
          },
        );
      },
    );
  }

  // 构建菜单项
  Widget _buildMenus() {
    return Consumer<UserModel>(
      builder: (BuildContext context, UserModel userModel, Widget child) {
        var gm = MyLocalizations.of(context);
        return ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.color_lens),
              title:Text(gm.theme),
              onTap: () => Navigator.pushNamed(context, "themes"),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(gm.language),
              onTap: () => Navigator.pushNamed(context, "language"),
            ),
            if(userModel.isLogin) ListTile(
              leading: const Icon(Icons.power_settings_new),
              title: Text(gm.logout),
              onTap: () => showAlert(context),
            ),
          ],
        );
      },
    );
  }

  void showAlert(BuildContext context) {
    var gm = MyLocalizations.of(context);
    showDialog(context: context, builder: (ctx) {
      //退出账号前先弹二次确认窗
      return AlertDialog(
        content: Text(gm.logoutTip),
        actions: <Widget>[
          FlatButton(
            child: Text(gm.cancel),
            onPressed: () => Navigator.pop(context),
          ),
          FlatButton(
            child: Text(gm.yes),
            onPressed: () {
              //该赋值语句会触发MaterialApp rebuild
              Navigator.pop(context);
            },
          ),
        ],
      );
    });
  }
}