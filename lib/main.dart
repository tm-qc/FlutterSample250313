import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
// import 'package:provider/provider.dart';

// class MyAppを呼びアプリの実行を Flutter に指示する
void main() {
  runApp(const MyApp());
}

// StatelessWidget を拡張しています
// ウィジェットは、すべての Flutter アプリを作成する際の元になる要素です
// 画面に表示されるすべてのものはウィジェットです。
// このアプリ自体がウィジェットです
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // これはアプリのテーマ設定です。
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }


}

// ChangeNotifier：自身の変更に関する通知を行うことができる
class MyAppState extends ChangeNotifier {
  // WordPair って何をするクラスか？
  // 英単語2つを組み合わせてくれるクラス
  // 簡単なチュートリアルの例でよく使われる
  var current = WordPair.random();
}

// 状態管理を登録
// このウィジェットはアプリのホームページです。これは「ステートフル（Stateful）」なウィジェットであり、
// 状態（State）オブジェクト（下で定義）を持ち、その中のフィールドが見た目に影響を与えます。

// このクラスは、その状態（State）のための設定を行います。
// 親ウィジェット（この場合は App ウィジェット）から渡された値（ここでは title）を保持し、
// Stateクラスの build メソッド内で使用されます。
// Widgetサブクラス内のフィールドは、常に「final（変更不可）」として定義されます。
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// 状態管理したい物を定義
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    // 状態の変化を検知
    // この setState の呼び出しは、Flutter フレームワークに「この State 内で何かが変化した」ことを伝えます。
    // その結果、下の build メソッドが再実行され、画面が最新の値を反映するように更新されます。
    // もし setState を使わずに _counter を変更しても、build メソッドは再実行されないため、
    // 見た目には何も変化が起こりません。
    setState(() {
      _counter++;
    });
  }

  // 状態変化を検知したら実行する処理
  // buildメソッドは、setState が呼ばれるたびに再実行されます。
  // たとえば、上の _incrementCounter メソッド内で setState が呼ばれた場合などです。
  //
  // Flutter フレームワークは、build メソッドの再実行を高速に処理できるよう最適化されています。
  // そのため、変更が必要な部分だけを再描画すればよく、
  // 各ウィジェットのインスタンスを個別に手動で更新する必要はありません。
  @override
  Widget build(BuildContext context) {
    // Scaffoldとは？
    // アプリ画面の「大枠」になるウィジェットで、1画面に基本的に 1つだけ使います。
    // つまり、レイアウトのコードの一番外側に置く「土台（骨組み）」の役割

    // Flutterアプリの 1ページ分（画面1つ） = Scaffold 1つ が基本
    // Scaffoldの中に、AppBar, body, FloatingActionButton, Drawer, BottomNavigationBar などを入れていく
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // ここでは、App.build メソッドによって作成された MyHomePage オブジェクトから値（title）を取得し、
        // AppBar のタイトルとして使用しています。
        title: Text(widget.title),
      ),
      // Center はレイアウト用のウィジェットです。
      // 1つの子ウィジェットを受け取り、それを親ウィジェットの中央に配置します。
      body: Center(
        // Column もレイアウト用のウィジェットです。
        // 子ウィジェットのリストを受け取り、それらを縦方向に並べます。
        // デフォルトでは、横幅は子ウィジェットに合わせて調整され、高さは親ウィジェットいっぱいまで広がろうとします。
        //
        // Column にはサイズや子ウィジェットの配置方法を制御するさまざまなプロパティがあります。
        // ここでは mainAxisAlignment を使って、子ウィジェットを縦方向の中央に配置しています。
        // Column は縦に並ぶため、メイン軸（main axis）は縦軸、クロス軸（cross axis）は横軸になります。
        //
        // 試してみましょう："debug painting" を有効にしてみてください
        // （IDEで "Toggle Debug Paint" を選ぶか、コンソールで "p" を押します）。
        // 各ウィジェットのワイヤーフレーム（枠線）が表示されます。
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            // とりあえず追加してみた
            ElevatedButton(
              onPressed: () {
                // 警告：本番コードで 'print' を使用しないでください。
                print('button pressed!');
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      // この末尾のカンマ（trailing comma）は、buildメソッド内のコードの自動整形をきれいにするためのものです
      // Flutterでは、末尾にカンマを付けると、自動フォーマット時にコードが縦に整形されて読みやすくなります。
    );
  }
}
