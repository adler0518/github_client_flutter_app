import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common/ShareModel.dart';
import 'l10n/index.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:github_client_flutter_app/routes/index.dart';


class App extends StatelessWidget {
  //This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider.value(value: ThemeModel()),
        ChangeNotifierProvider.value(value: UserModel()),
        ChangeNotifierProvider.value(value: LocaleModel()),
      ],
      child: Consumer2<ThemeModel, LocaleModel>(
        builder: (BuildContext context, themeModel, localeModel, Widget child){
          return MaterialApp(
            theme: ThemeData(
              primarySwatch: themeModel.theme,
            ),
            onGenerateTitle: (context){
              return MyLocalizations.of(context).title();
            },
            locale: localeModel.getLocale(),  //Not use system language to chanage when is not null.
            //We only supper english and chinese language.
            supportedLocales: [
              const Locale('en', 'US'), // English
              const Locale('zh', 'CN'), // Chinese
              //Other Locales
            ],
            localizationsDelegates: [
              // Location delegate class
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              MyLocalizationsDelegate()
            ],
            //Listen system language
            localeResolutionCallback: (Locale _locale, Iterable<Locale> supportedLocales) {
              if (localeModel.getLocale() != null) {
                //Not use system language when profile have a set locale property.
                return localeModel.getLocale();
              } else {
                Locale locale;
                //APP use system language to change.
                //Set locale is en while system language is not english or chinese.
                if (supportedLocales.contains(_locale)) {
                  locale= _locale;
                } else {
                  locale= Locale('en', 'US');
                }
                return locale;
              }
            },
            home: HomeRoute(), //App home entry
            routes: <String, WidgetBuilder>{
              "login": (context) => LoginRoute(),
              "themes": (context) => ThemeChangeRoute(),
              "language": (context) => LanguageRoute(),
            }
          );
        }
      ),
    );
  }
}




