import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../global.dart';

class WebsitePage extends StatefulWidget {
  const WebsitePage({Key? key}) : super(key: key);

  @override
  State<WebsitePage> createState() => _WebsitePageState();
}

class _WebsitePageState extends State<WebsitePage> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  String url = "";
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(
                url: Uri.parse("${Global.currentWeb["website"]}"),
              ),
              initialOptions: options,
              pullToRefreshController: pullToRefreshController,
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStop: (controller, url) async {
                pullToRefreshController.endRefreshing();
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    backgroundColor: Color(Global.currentWeb["color"]),
                    onPressed: () {
                      webViewController?.goBack();
                    },
                    mini: true,
                    child: const Icon(Icons.arrow_back_ios_new_outlined),
                  ),
                  FloatingActionButton(
                    backgroundColor: Color(Global.currentWeb["color"]),
                    onPressed: () {
                      Global.bookMarksList.add(url);
                      Global.bookMarksList =
                          Global.bookMarksList.toSet().toList();
                    },
                    mini: true,
                    child: const Icon(Icons.bookmark_add_outlined),
                  ),
                  FloatingActionButton(
                    backgroundColor: Color(Global.currentWeb["color"]),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            backgroundColor: Colors.black,
                            shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: const Center(
                                child: Text('All Bookmarks',
                                    style: TextStyle(color: Colors.yellow))),
                            content: SizedBox(
                              height: MediaQuery.of(context).size.width * 0.75,
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: ListView.separated(
                                itemCount: Global.bookMarksList.length,
                                itemBuilder: (context, i) {
                                  return ListTile(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      webViewController?.loadUrl(
                                        urlRequest: URLRequest(
                                          url: Uri.parse(
                                              Global.bookMarksList[i]),
                                        ),
                                      );
                                    },
                                    title: Text(
                                      Global.bookMarksList[i],
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.blueAccent),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, i) {
                                  return const Divider(
                                    color: Colors.black,
                                    endIndent: 30,
                                    indent: 30,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    mini: true,
                    child: const Icon(Icons.bookmark_border),
                  ),
                  FloatingActionButton(
                    backgroundColor: Color(Global.currentWeb["color"]),
                    onPressed: () {
                      webViewController?.loadUrl(
                        urlRequest: URLRequest(
                          url: Uri.parse(Global.currentWeb["website"]),
                        ),
                      );
                    },
                    mini: true,
                    child: const Icon(Icons.home),
                  ),
                  FloatingActionButton(
                    backgroundColor: Color(Global.currentWeb["color"]),
                    onPressed: () {
                      webViewController?.reload();
                    },
                    mini: true,
                    child: const Icon(Icons.refresh),
                  ),
                  FloatingActionButton(
                    backgroundColor: Color(Global.currentWeb["color"]),
                    onPressed: () {
                      webViewController?.goForward();
                    },
                    mini: true,
                    child: const Icon(Icons.arrow_forward_ios_sharp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
