import 'dart:convert';
import 'package:assignment/DetailsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'main.dart';

class Second extends StatefulWidget {
  const Second({Key? key}) : super(key: key);
  @override
  _SecondState createState() => _SecondState();
}

class _SecondState extends State<Second> {

  List<String> name = [], slug = [], img =[], year =[], noSlug =[];
  ScrollController bigController = ScrollController();
  late List<ScrollController> littleController;

  @override
  void initState() {
    // TODO: implement initState
    http.get(Uri.parse("https://followchess.com/config.json")).then((response) {
      print(response.body);
      jsonDecode(response.body)["trns"].forEach((map){
        name.add(map["name"]);
        slug.add(map["slug"]);
        img.add(map["img"].toString());
      });
    }).then((value) {
      int i = 0;
      slug.forEach((element) {
        year.add(element.split("-").last);
        noSlug.add(element.split("-").length.toString());
        List<String> temp = element.split("-");
        temp.removeAt(int.parse(noSlug[i]) - 1);
        slug[i] = temp.join(" ");
        i++;
      });

      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Color(0xff810a3b10)));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backwardsCompatibility: false,
          backgroundColor: Colors.black,
          title: Text("Hope!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        ),
        body: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: [
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400.0,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                childAspectRatio: 2.0,
              ),
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        width: width/411 * width,
                        height: 200/411 * width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Image.network(img[index],
                            fit: BoxFit.fitWidth,
                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                              return Image.asset("assets/avatar.png",
                                height: 137/411 * width,
                                width:  234/411 * width,
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        width: width/411 * width,
                        height: 100/411 * width,
                        color: Colors.black54,
                        child: Padding(
                          padding: EdgeInsets.only(left: 15.0/411 * width),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name[index], style: TextStyle(color: Colors.white, fontSize: 15/411 * width, fontWeight: FontWeight.w400)),
                              Text(slug[index], style: TextStyle(color: Colors.white, fontSize: 18/411 * width, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis,),
                              Text(year[index], style: TextStyle(color: Colors.white, fontSize: 15/411 * width, fontWeight: FontWeight.w400)),
                              Text(noSlug[index], style: TextStyle(color: Colors.white, fontSize: 15/411 * width, fontWeight: FontWeight.w400)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
                childCount: slug.length,
              ),
            )
          ],
        )
      ),
    );
  }
}

/**/
