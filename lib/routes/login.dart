import 'package:flutter/material.dart';
import 'package:github_client_app/common/Global.dart';
import 'package:github_client_app/l10n/MyLocalizations.dart';
import 'package:github_client_app/models/index.dart';
import 'package:provider/provider.dart';
import 'package:github_client_app/common/ShareModel.dart';
import 'package:github_client_app/common/Network.dart';
import 'package:toast/toast.dart';

class LoginRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginRouteState();
  }
}

class _LoginRouteState extends State<LoginRoute> {
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  bool pwdShow = false; //Whether password is displayed in clear text.
  GlobalKey _formKey = new GlobalKey<FormState>();
  bool _nameAutoFocus = true;

  @override
  void initState(){
    //Automatically fill in the use name that was successfully login in last time.
    //Then move the focus to password text input box.
    _unameController.text = Global.profile.lastLogin;
    if (_unameController.text != null) {
      _nameAutoFocus = false;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var gm = MyLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(gm.login())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(
            children: <Widget>[
              TextFormField(
                autofocus: _nameAutoFocus,
                controller: _unameController,
                decoration: InputDecoration(
                  labelText: gm.userName(),
                  hintText: gm.userNameOrEmail(),
                  prefixIcon: Icon(Icons.person),
                ),
                //verify use name(not empty)
                validator: (v){
                  return v.trim().isNotEmpty ? null : gm.userNameRequired();
                },
              ),
              TextFormField(
                controller: _pwdController,
                autofocus: !_nameAutoFocus,
                decoration: InputDecoration(
                    labelText: gm.password(),
                    hintText: gm.password(),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                          pwdShow ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          pwdShow = !pwdShow;
                        });
                      },
                    )),
                obscureText: !pwdShow,
                //校验密码（不能为空）
                validator: (v) {
                  return v.trim().isNotEmpty ? null : gm.passwordRequired();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(height: 55.0),
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: _onLogin,
                    textColor: Colors.white,
                    child: Text(gm.login()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onLogin() async {
    print('sssssss');

    // 提交前，先验证各个表单字段是否合法
    if ((_formKey.currentState as FormState).validate()) {
//      showLoading(context);
      User user;
      try {
        user = await Git(context).login(_unameController.text, _pwdController.text);
        // 因为登录页返回后，首页会build，所以我们传false，更新user后不触发更新
        Provider.of<UserModel>(context, listen: false).user = user;
      } catch (e) {
        //登录失败则提示
        if (e.response?.statusCode == 401) {
          showToast(MyLocalizations.of(context).userNameOrPasswordWrong());
        } else {
          showToast(e.toString());
        }
      } finally {
        // 隐藏loading框showDialog
        Navigator.of(context).pop();
      }
      if (user != null) {
        // 返回
        Navigator.of(context).pop();
      }
    }

    print('eeeeeeee');
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}