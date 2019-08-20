import 'package:flutter/material.dart';
import 'package:github_client_app/l10n/MyLocalizations.dart';

class ThemeChangeRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var gm = MyLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(gm.theme),
      ),
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Text('Developing'),
      ),
    );
  }
}