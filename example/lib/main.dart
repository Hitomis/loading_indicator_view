import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator_view/loading_indicator_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _orderNum = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 185, 63, 81),
      body: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1.0,
        ),
        children: <Widget>[
          wrapOrder(Center(child: LineSpinFadeLoaderIndicator())),
          wrapOrder(Center(child: BallBeatIndicator())),
          wrapOrder(Center(child: BallClipRotateMultipleIndicator())),
          wrapOrder(Center(child: BallGridPulseIndicator())),
          wrapOrder(Center(child: LineScaleIndicator())),
          wrapOrder(Center(child: BallPulseRiseIndicator())),
          wrapOrder(Center(child: BallScaleRippleMultipleIndicator())),
          wrapOrder(Center(child: BallZigZagIndicator())),
          wrapOrder(Center(child: BallScaleIndicator())),
          wrapOrder(Center(child: BallPulseSyncIndicator())),
          wrapOrder(Center(child: BallScaleMultipleIndicator())),
          wrapOrder(Center(child: BallPulseIndicator())),
          wrapOrder(Center(child: BallClipRotatePulseIndicator())),
          wrapOrder(Center(child: BallGridBeatIndicator())),
          wrapOrder(Center(child: SquareSpinIndicator())),
          wrapOrder(Center(child: BallSpinFadeLoaderIndicator())),
          wrapOrder(Center(child: BallScaleRippleIndicator())),
          wrapOrder(Center(child: SemiCircleSpinIndicator())),
          wrapOrder(Center(child: LineScalePulseOutIndicator())),
          wrapOrder(Center(child: BallClipRotateIndicator())),
          wrapOrder(Center(child: PacmanIndicator())),
          wrapOrder(Center(child: BallRotateIndicator())),
          wrapOrder(Center(child: CubeTransitionIndicator())),
          wrapOrder(Center(child: TriangleSkewSpinIndicator())),
        ],
      ),
    );
  }


  @override
  void didUpdateWidget(MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget != widget) {
      _orderNum = 1;
    }
  }

  Widget wrapContainer(Widget child, [Color backgroundColor = Colors.green]) =>
      Container(color: backgroundColor, child: child);

  Widget wrapOrder(Widget child) => Stack(children: <Widget>[
    child,
    Positioned(
      left: 8,
      bottom: 0,
      child: Text("${_orderNum++}",
          style: TextStyle(color: Colors.white, fontSize: 18)),
    ),
  ]);
}
