import 'package:flutter/material.dart';
import "calculateDerivations.dart";
import "calculateRoots.dart";
import "calculateExtremes.dart";
import "drawGraph.dart";

List<String> derivations = ["", "", ""];
List<List<List<num>>> extremes = [];
String roots = "";
String function = "";
final TextEditingController _controller = new TextEditingController();

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Kurvendiskussion',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Ableitungen berechnen'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          new InputWidget(),
        ]
      ),
    );
  }
}

class ResultsRoute<T> extends MaterialPageRoute<T> {
  ResultsRoute({
    WidgetBuilder builder,
  }): super(builder: builder);

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child)
  {
    if (settings.isInitialRoute)
      return child;

    return new SlideTransition(
      position: new FractionalOffsetTween(
        begin: FractionalOffset.topRight,
        end: FractionalOffset.topLeft
      )
      .animate(
        new CurvedAnimation(
          parent: animation,
          curve: Curves.ease,
        )
      ),
      child: child,
    );
  }

  @override Duration get transitionDuration => const Duration(milliseconds: 400);
}

class InputWidget extends StatefulWidget {
  @override
  InputWidgetState createState() => new InputWidgetState();
}



class InputWidgetState extends State<InputWidget> {

  @override
  Widget build(BuildContext context) {

    return new Column(
        children: [
          new Text("Funktion hier eingeben:", style: new TextStyle(fontSize: 20.0, color: Colors.blue, fontFamily: "Raleway")),
          new TextField(
            controller: _controller,
            textAlign: TextAlign.center,
            style: new TextStyle(fontSize: 20.0, color: Colors.blue),
          ),
          new IconButton(
            icon: new Icon(Icons.search),
            iconSize: 40.0,
            color: new Color.fromARGB(255, 88, 88, 88),
            onPressed: () {
              populateDerivations();
              roots = calculateRoots(function).toString();
              extremes = calculateExtremes(function, derivations[0]);

              navigateToResults(context);
            },
          )
        ]
    );
  }
}

class MyCustomView extends StatelessWidget {

  TextStyle textStyle = new TextStyle(fontSize: 17.5, fontFamily: "Raleway", color: new Color.fromARGB(255, 230, 230, 230));

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(title: new Text("Ergebnisse", style: new TextStyle(fontFamily: "Raleway"))),
      body: new ListView(
        children: [
          new Container(
            width: 500.0,
            padding: new EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
            color: new Color.fromARGB(255, 53, 126, 92),
            child: new Column(
              children: [
                new Container(
                  padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                  child: new Text("Ableitungen", style: new TextStyle(fontSize: 30.0, fontFamily: "Barrio", color: new Color.fromARGB(255, 230, 230, 230))),
                ),
                new Text("f'(x) = ${derivations[0]}", style: textStyle),
                new Text("f''(x) = ${derivations[1]}", style: textStyle),
                new Text("f'''(x) = ${derivations[2]}", style: textStyle),
              ]
            ),
          ),
          new Container(
            width: 500.0,
            padding: new EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
            color: new Color.fromARGB(255, 13, 50, 76),
            child: new Column(
              children: [
                new Container(
                  padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                  child: new Text("Nullstellen", style: new TextStyle(fontSize: 30.0, fontFamily: "Barrio", color: new Color.fromARGB(255, 230, 230, 230))),
                ),
                new Text(roots, style: textStyle),
              ]
            ),
          ),
          new Container(
            width: 500.0,
            padding: new EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
            color: new Color.fromARGB(255, 140, 140, 52),
            child: new Column(
              children: [
                new Container(
                  padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                  child: new Text("Extremstellen", style: new TextStyle(fontSize: 30.0, fontFamily: "Barrio", color: new Color.fromARGB(255, 230, 230, 230))),
                ),
                new Text("Minima: ${extremes[0][0].toString()}" , style: textStyle),
                new Text("Maxima: ${extremes[1][0].toString()}" , style: textStyle),
                new Text("Wendepunkte: ${extremes[2][0].toString()}" , style: textStyle),
              ]
            ),
          ),
          new Container(
            width: 500.0,
            padding: new EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
            color: new Color.fromARGB(255, 53, 126, 92),
            child: new Column(
              children: [
                new Container(
                  padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                  child: new Text("Graph", style: new TextStyle(fontSize: 30.0, fontFamily: "Barrio", color: new Color.fromARGB(255, 230, 230, 230))),
                ),
                new CustomPaint(
                  size: new Size(100.0, 150.0),
                  painter: new BarChartPainter(0.0),
                ),
              ]
            ),
          ),
        ]
      ),
    );
  }
}

void populateDerivations(){
  function = _controller.text;
  derivations[0] = makeFunction(function);
  derivations[1] = makeFunction(derivations[0]);
  derivations[2] = makeFunction(derivations[1]);

  derivations = simplifyAllFunctions(derivations);
}

void navigateToResults(BuildContext context){
  Navigator.push(context, new ResultsRoute(
    builder: (_) => new MyCustomView()
  ));
}
