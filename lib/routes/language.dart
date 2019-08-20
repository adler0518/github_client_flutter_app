import 'package:flutter/material.dart';
import 'package:github_client_flutter_app/l10n/MyLocalizations.dart';

class LanguageRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var gm = MyLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(gm.language),
      ),
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Text('Developing'),
      ),
    );
  }
}