import 'package:flutter/material.dart';

import '../global.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          "OTT platforms",
          style: TextStyle(
            color: Colors.yellow.shade700,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
            wordSpacing: 5,
          ),
        ),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: Global.websiteList.length,
        itemBuilder: (context, i) {
          return Container(
            margin: const EdgeInsets.only(left: 20, top: 25, right: 20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              splashColor:
                  Color(Global.websiteList[i]["color"]).withOpacity(0.2),
              onTap: () {
                Global.currentWeb = Global.websiteList[i];
                Navigator.of(context).pushNamed("website_page");
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Color(Global.websiteList[i]["color"]),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset.fromDirection(10, -5),
                    )
                  ],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 2,
                    color: Color(Global.websiteList[i]["color"]),
                  ),
                ),
                alignment: Alignment.center,
                height: 100,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 30),
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Color(Global.websiteList[i]["color"])
                          .withOpacity(0.2),
                      backgroundImage:
                          NetworkImage(Global.websiteList[i]["image"]),
                    ),
                    const SizedBox(width: 30),
                    Text(
                      "${Global.websiteList[i]["name"]}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                        color: Color(Global.websiteList[i]["color"]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
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
                    child: Text(
                  'All Bookmarks',
                  style: TextStyle(color: Colors.yellow),
                )),
                content: SizedBox(
                  height: MediaQuery.of(context).size.width * 0.75,
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: ListView.separated(
                    itemCount: Global.bookMarksList.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).pop();
                          Global.currentWeb["website"] =
                              Global.bookMarksList[i];
                          Navigator.of(context).pushNamed("website_page");
                        },
                        title: Text(
                          Global.bookMarksList[i],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.blueAccent),
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
        backgroundColor: Colors.yellow.shade700,
        child: const Icon(Icons.bookmark_border, color: Colors.black),
      ),
    );
  }
}
