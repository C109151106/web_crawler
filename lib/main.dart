import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:html/dom.dart' as dom;
import 'dart:convert';
import 'dart:io';
import 'package:chaleno/chaleno.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}
class oil_class {
  String oil_type='';
  String oil_price='';

  oil_class(String oil_type, String oil_price) {
    this.oil_type = oil_type;
    this.oil_price = oil_price;

  }
}
List<oil_class> oil = <oil_class>[];
var login=true;
class _MyAppState extends State<MyApp> {
  final tabs=[
    Center(child: screen1()),
    Center(child: screen2()),
    Center(child: screen3()),
    Center(child: screen4()),
  ];

  int _currentindex=0;
  @override
  void initState() {
    super.initState();
    this.html_parse();
  }

  var header = {
    'user-agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) ' +
        'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36',
  };


  request_data() async {
    // var url = Uri.parse("https://www.cpc.com.tw/historyprice.aspx?n=2890");
    var url = Uri.parse("http://www.fpcc.com.tw/tw/price");

    var response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      print('ok!');
      return response.body;
    }
    else {
      print('error');
    }
    return '<html>error! status:${response.statusCode}</html>';
  }


  html_parse() async {
    // final chaleno = await Chaleno().load('https://www.cpc.com.tw');
    // Result? result = chaleno?.getElementById('t_sPrice1');
    // print(result?.text);
    var html = await request_data();
    var document = parse(html);
    // 這裡使用css選擇器語法提取資料
    // var t = document.getElementsByClassName('today_price_ct')[0];
    // print(t.children[0].children[1].text.trim());
    // print(t.children[1].children[1].text.trim());
    var html_result = document.getElementsByClassName('gps');
    for (var html in html_result) {
      var oil_name = html.children[1].text.trim();
      var oil_price = html.children[0].text.trim();
      oil.add(new oil_class(oil_name, oil_price));
      print(oil_name);
      print(oil_price);
    }
    print(oil.length);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 3)), //用於載入資料的時間
      builder: (context, AsyncSnapshot snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting && login) {
          return MaterialApp(
            home: SplashPage(),
          );
        }

        // Main
        else {
          login=false;
          return MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: Text('油價查詢APP'),),
              body: tabs[_currentindex],
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.blue,
                selectedItemColor: Colors.white,
                selectedFontSize: 18.0,
                unselectedFontSize: 14.0,
                iconSize: 30.0,
                currentIndex: _currentindex,
                items: [
                  BottomNavigationBarItem(icon: Icon(Icons.home),
                    label: '汽油及柴油',
                  ),
                  BottomNavigationBarItem(icon: Icon(Icons.book_outlined),
                    label: '油品批售價',
                  ),
                  BottomNavigationBarItem(icon: Icon(Icons.fact_check_outlined),
                    label: '液化石油氣',
                  ),
                  BottomNavigationBarItem(icon: Icon(Icons.fork_right),
                    label: '航空燃油',
                  ),
                ],
                onTap: (index) { setState(() {
                  _currentindex=index;
                });
                },
              ),
            ),
          );
        }
      },
    );
  }
}
// SplashPage
class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFcccccc),
      body:
            Center(
              child: Icon(
                Icons.oil_barrel_outlined,
                size: MediaQuery.of(context).size.width * 0.7,
              ),
            ),
    );
  }
}

class screen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:Column(
        children: [
              //有多種排版方式, 此處以最直覺的方式將每一列放文字內容
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Colors.purple,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                      image: AssetImage('images/1.jpeg'),
                      fit: BoxFit.cover ,
                    ),
                    color: Colors.white,
                  ),
                ),
          //----------------92---------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 160,
                    height: 60,
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
                    decoration: BoxDecoration(
                      // border: Border.all(color: Colors.lightGreen, width: 3),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [ BoxShadow(color: Colors.green,
                          offset: Offset(6, 6)),
                      ],),
                    child:Text(oil[0].oil_type,textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25,color: Colors.white),),
                  ),
                  Container(
                    width: 160,
                    height: 60,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
                    decoration: BoxDecoration(
                      // border: Border.all(color: Colors.lightGreen, width: 3),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [ BoxShadow(color: Colors.green,
                          offset: Offset(6, 6)),
                      ],),
                    child:Text(oil[0].oil_price,textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 35,color: Colors.white),),
                  ),
                ],
              ),
        //--------------------95+---------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 160,
                      height: 60,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.blueAccent, width: 3),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [ BoxShadow(color: Colors.blue,
                            offset: Offset(6, 6)),
                        ],),
                      child:Text(oil[1].oil_type,textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25,color: Colors.white),),
                    ),
                    Container(
                      width: 160,
                      height: 60,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.blueAccent, width: 3),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [ BoxShadow(color: Colors.blue,
                            offset: Offset(6, 6)),
                        ],),
                      child:Text(oil[1].oil_price,textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 35,color: Colors.white),),
                    ),
                  ],
                ),
          //--------------------98-----------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 160,
                      height: 60,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.blueAccent, width: 3),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [ BoxShadow(color: Colors.purpleAccent,
                            offset: Offset(6, 6)),
                        ],),
                      child:Text(oil[2].oil_type,textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25,color: Colors.white),),
                    ),
                    Container(
                      width: 160,
                      height: 60,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.blueAccent, width: 3),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [ BoxShadow(color: Colors.purpleAccent,
                            offset: Offset(6, 6)),
                        ],),
                      child:Text(oil[2].oil_price,textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 35,color: Colors.white),),
                    ),
                  ],
                ),
        //----------------------柴油---------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 160,
                      height: 60,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.blueAccent, width: 3),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [ BoxShadow(color: Colors.black,
                            offset: Offset(6, 6)),
                        ],),
                      child:Text(oil[3].oil_type,textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25,color: Colors.white),),
                    ),
                    Container(
                      width: 160,
                      height: 60,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.blueAccent, width: 3),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [ BoxShadow(color: Colors.black,
                            offset: Offset(6, 6)),
                        ],),
                      child:Text(oil[3].oil_price,textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 35,color: Colors.white),),
                    ),
                  ],
                ),

            ],
          ),
    );
  }
}

class screen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:Column(
        children: [
          //有多種排版方式, 此處以最直覺的方式將每一列放文字內容
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Colors.purple,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                image: AssetImage('images/2.jpeg'),
                fit: BoxFit.cover ,
              ),
              color: Colors.white,
            ),
          ),
          //----------------92---------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 160,
                height: 60,
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.lightGreen, width: 3),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [ BoxShadow(color: Colors.green,
                      offset: Offset(6, 6)),
                  ],),
                child:Text(oil[4].oil_type,textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25,color: Colors.white),),
              ),
              Container(
                width: 160,
                height: 60,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.lightGreen, width: 3),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [ BoxShadow(color: Colors.green,
                      offset: Offset(6, 6)),
                  ],),
                child:Text(oil[4].oil_price,textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 35,color: Colors.white),),
              ),
            ],
          ),
          //--------------------95+---------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 160,
                height: 60,
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.blueAccent, width: 3),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [ BoxShadow(color: Colors.blue,
                      offset: Offset(6, 6)),
                  ],),
                child:Text(oil[5].oil_type,textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25,color: Colors.white),),
              ),
              Container(
                width: 160,
                height: 60,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.blueAccent, width: 3),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [ BoxShadow(color: Colors.blue,
                      offset: Offset(6, 6)),
                  ],),
                child:Text(oil[5].oil_price,textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 35,color: Colors.white),),
              ),
            ],
          ),
          //--------------------98-----------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 160,
                height: 60,
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.blueAccent, width: 3),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [ BoxShadow(color: Colors.purpleAccent,
                      offset: Offset(6, 6)),
                  ],),
                child:Text(oil[6].oil_type,textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25,color: Colors.white),),
              ),
              Container(
                width: 160,
                height: 60,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.blueAccent, width: 3),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [ BoxShadow(color: Colors.purpleAccent,
                      offset: Offset(6, 6)),
                  ],),
                child:Text(oil[6].oil_price,textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 35,color: Colors.white),),
              ),
            ],
          ),
          //----------------------柴油---------------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 160,
                height: 60,
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.blueAccent, width: 3),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [ BoxShadow(color: Colors.black,
                      offset: Offset(6, 6)),
                  ],),
                child:Text(oil[7].oil_type,textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25,color: Colors.white),),
              ),
              Container(
                width: 160,
                height: 60,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.blueAccent, width: 3),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [ BoxShadow(color: Colors.black,
                      offset: Offset(6, 6)),
                  ],),
                child:Text(oil[7].oil_price,textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 35,color: Colors.white),),
              ),
            ],
          ),

        ],
      ),
    );
  }
}

class screen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:Column(
        children: [
          //有多種排版方式, 此處以最直覺的方式將每一列放文字內容
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Colors.purple,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                image: AssetImage('images/3.jpeg'),
                fit: BoxFit.cover ,
              ),
              color: Colors.white,
            ),
          ),

          //--------------------液化石油氣 （混合丙丁烷）-----------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 190,
                height: 95,
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.blueAccent, width: 3),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [ BoxShadow(color: Colors.purpleAccent,
                      offset: Offset(6, 6)),
                  ],),
                child:Text(oil[8].oil_type,textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25,color: Colors.white),),
              ),
              Container(
                width: 160,
                height: 100,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.blueAccent, width: 3),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [ BoxShadow(color: Colors.purpleAccent,
                      offset: Offset(6, 6)),
                  ],),
                child:Text(oil[8].oil_price,textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 35,color: Colors.white),),
              ),
            ],
          ),
          //---------------------液化石油氣（工業用丙烷）-----------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 190,
                height: 95,
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.blueAccent, width: 3),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [ BoxShadow(color: Colors.black,
                      offset: Offset(6, 6)),
                  ],),
                child:Text(oil[9].oil_type,textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25,color: Colors.white),),
              ),
              Container(
                width: 160,
                height: 100,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.blueAccent, width: 3),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [ BoxShadow(color: Colors.black,
                      offset: Offset(6, 6)),
                  ],),
                child:Text(oil[9].oil_price,textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 35,color: Colors.white),),
              ),
            ],
          ),

        ],
      ),
    );
  }
}

class screen4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:Column(
        children: [
          //有多種排版方式, 此處以最直覺的方式將每一列放文字內容
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Colors.purple,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                image: AssetImage('images/4.png'),
                fit: BoxFit.cover ,
              ),
              color: Colors.white,
            ),
          ),
          //----------------92---------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 180,
                height: 70,
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.lightGreen, width: 3),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [ BoxShadow(color: Colors.green,
                      offset: Offset(6, 6)),
                  ],),
                child:Text(oil[11].oil_type,textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25,color: Colors.white),),
              ),
              Container(
                width: 160,
                height: 70,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.lightGreen, width: 3),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [ BoxShadow(color: Colors.green,
                      offset: Offset(6, 6)),
                  ],),
                child:Text(oil[11].oil_price,textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 35,color: Colors.white),),
              ),
            ],
          ),
          //--------------------95+---------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 185,
                height: 65,
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.blueAccent, width: 3),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [ BoxShadow(color: Colors.blue,
                      offset: Offset(6, 6)),
                  ],),
                child:Text(oil[12].oil_type,textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25,color: Colors.white),),
              ),
              Container(
                width: 160,
                height: 60,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.blueAccent, width: 3),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [ BoxShadow(color: Colors.blue,
                      offset: Offset(6, 6)),
                  ],),
                child:Text(oil[12].oil_price,textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 35,color: Colors.white),),
              ),
            ],
          ),
          //--------------------98-----------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 185,
                height: 65,
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.blueAccent, width: 3),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [ BoxShadow(color: Colors.purpleAccent,
                      offset: Offset(6, 6)),
                  ],),
                child:Text(oil[13].oil_type,textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25,color: Colors.white),),
              ),
              Container(
                width: 160,
                height: 60,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.blueAccent, width: 3),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [ BoxShadow(color: Colors.purpleAccent,
                      offset: Offset(6, 6)),
                  ],),
                child:Text(oil[13].oil_price,textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 35,color: Colors.white),),
              ),
            ],
          ),
          //----------------------柴油---------------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 185,
                height: 65,
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.blueAccent, width: 3),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [ BoxShadow(color: Colors.black,
                      offset: Offset(6, 6)),
                  ],),
                child:Text(oil[14].oil_type,textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25,color: Colors.white),),
              ),
              Container(
                width: 160,
                height: 60,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.blueAccent, width: 3),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [ BoxShadow(color: Colors.black,
                      offset: Offset(6, 6)),
                  ],),
                child:Text(oil[14].oil_price,textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 35,color: Colors.white),),
              ),
            ],
          ),

        ],
      ),
    );
  }
}