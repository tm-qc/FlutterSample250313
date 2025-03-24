import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 流れは
// 1. void mainでアプリ起動
// 2. MyAppがアプリのルートなど基盤の設定
// 3. MyAppState 起動ページで利用する変数を定義。
// 4. MyHomePageアプリのメイン機能

// MyApp で定義したアプリの実行を Flutter に指示する
void main() {
  runApp(MyApp());
}

// StatelessWidget
// すべての Flutter アプリを作成する際の元になる要素です。
// このアプリ自体がウィジェット
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ChangeNotifier：自身の変更に関する通知を行うことができる
    // 状態は ChangeNotifierProvider を使用して作成されてアプリ全体に提供されます
    // これにより、アプリ内のどのウィジェットも状態を取得できるようになります
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

// アプリが機能するために必要となるデータを定義します
class MyAppState extends ChangeNotifier {
  // ランダムな単語のペアを収めた変数
  var current = WordPair.random();

  // current に新しいランダムな WordPair を再代入します
  void getNext() {
    current = WordPair.random();
    // 監視している MyAppState に通知するために notifyListeners()（ChangeNotifier) のメソッド）の呼び出しも行います。
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  // 警告：Constructors for public widgets should have a named 'key' parameter.が出てたので追加
  // FlutterのLintルール（コード品質のルール） のひとつで、公開クラス（外部から使われるWidget）にはkeyパラメータを明示的に定義するべきというルール
  const MyHomePage({super.key});
  // @overrideって？
  // 「親のbuild()を自分用に書き直してるよ」ということを明示
  @override
  // Widgetを表示するとき（初回や再描画時）に必ず呼ばれるメソッド
  Widget build(BuildContext context) {

    // watch メソッドを使用してアプリの現在の状態に対する変更を追跡
    var appState = context.watch<MyAppState>();

    return Scaffold(
      // Flutter における非常に基本的なレイアウト ウィジェットです
      // 任意の数の子を従え、それらを上から下へ一列に配置します
      body: Column(
        children: [
          Text('A random idea:ABC'),
          Text(appState.current.asLowerCase),
          // ボタン追加
          ElevatedButton(
            onPressed: () {
              // イベントトリガー
              appState.getNext();
            },
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}