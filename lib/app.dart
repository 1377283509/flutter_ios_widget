import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

import 'UserPage.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  StreamSubscription<String> _sub;

  @override
  void initState() {
    super.initState();
    initPlatformStateForStringUniLinks();
  }

  Future<void> initPlatformStateForStringUniLinks() async {
    String initialLink;
    // App未打开的状态在这个地方捕获scheme
    try {
      initialLink = await getInitialLink();
      print('跳转地址: $initialLink');
      if (initialLink != null) {
        print('跳转地址不为null --$initialLink');
        //  跳转到指定页面
        schemeJump(context, initialLink);
      }
    } on PlatformException {
      initialLink = 'Failed to get initial link.';
    } on FormatException {
      initialLink = 'Failed to parse the initial link as Uri.';
    }
    // App打开的状态监听scheme
    _sub = getLinksStream().listen((String link) {
      if (!mounted || link == null) return;
      print('link--$link');
      //  跳转到指定页面
      schemeJump(context, link);
    }, onError: (Object err) {
      if (!mounted) return;
    });
  }

  void schemeJump(BuildContext context, String schemeUrl) {
    final Uri _jumpUri = Uri.parse(schemeUrl.replaceFirst(
      'dynamictheme://',
      'http://path/',
    ));
    switch (_jumpUri.path) {
      case '/user':
        print("接收到的参数为：");
        String userid = _jumpUri.queryParameters["userid"];
        print(userid);
        String author = _jumpUri.queryParameters["author"];
        print(author);

        Navigator.of(navigatorKey.currentContext).push(CupertinoPageRoute(
            builder: (context) => UserPage(
                  userid: userid,
                  author: author,
                )));
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter 与 IOS',
      theme:
      ThemeData(primarySwatch: Colors.blue, platform: TargetPlatform.iOS),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage")
      ),
      body: Center(
        child: Text("Home page"),
      ),
    );
  }
}

