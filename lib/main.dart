import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    var shell = Shell();
    var results = shell.runSync("canon 1ne4 -v");
    var lines = results.outLines;
    List<String> verses = [];
    String chapter = "";
    String path = "";
    for (var l in lines) {
      if (l.startsWith("@@@")) {
        verses.add(l.substring(3));
      } else if (l.startsWith("@@")) {
        chapter = l.substring(2);
      } else if (l.startsWith("@")) {
        path = l.split("/").lastWhere((el)=> el.isNotEmpty);
      }
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: MyHomePage(chapter: chapter, path: path, verses: verses),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.chapter, required this.path, required this.verses});

  final String chapter;
  final String path;
  final List<String> verses;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var title = "${widget.path} ${widget.chapter}";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: ScriptureView(verses: widget.verses, title: "CHAPTER ${widget.chapter}")
      ),
      //floatingActionButton: FloatingActionButton(
      //  onPressed: () {},
      //  tooltip: 'Increment',
      //  child: const Icon(Icons.add),
      //),
    );
  }
}

class ScriptureView extends StatelessWidget {
  const ScriptureView({super.key, required this.verses, this.title});

  final List<String> verses;
  final String? title;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          children: [
            if (title != null) Text(
              title!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, height: 2)
            ),
            SelectableText.rich(
              TextSpan(
                children: _generateSpans(verses),
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ]
        ),
      ),
    );
  }

  List<InlineSpan> _generateSpans(List<String> text) {
    List<InlineSpan> result = []; 
    for (String verse in text) {
      result.add(TextSpan(text: '$verse\n'));
      result.add(const WidgetSpan(
        child: SizedBox(height: 28),
      ));
    }
    return result;
  }
}

