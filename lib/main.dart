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
        // Material Design 3 を使用することを指定
        // アプリの基本デザインをMaterial Design 3のテーマデータに沿って作成するということ
        // 特に設定していなければ、Flutter は デフォルトのテーマ を使用する

        // CSS のように「外部スタイルファイルを作って適用する」仕組みは Flutter にはない。
        // ただし、代わりに ThemeData や TextStyle などを統一管理する のが一般的らしいです
        theme: ThemeData(
          useMaterial3: true,
          // 任意の色を選択することもできます
          // 例）Colors.deepOrange→Colors.blueなど
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
    var pair = appState.current;

    return Scaffold(
      // Flutter における非常に基本的なレイアウト ウィジェットです
      // 任意の数の子を従え、それらを上から下へ一列に配置します
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('A random idea:ABC'),
            BigCard(pair: pair),
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
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    // MaterialAppで設定されたテーマデータを取得
    // アプリ全体が対象の Theme を使用するメリットは関連も自動で変わるので、修正漏れがなく統一性がでるということ
    final theme = Theme.of(context);

    // final：宣言時に一度だけ値を設定できます。
    // 　　　　その後、変数の値を変更しようとするとコンパイルエラーが発生します。
    // 　　　　意図しない変更を防ぐために使用されます。
    //
    // finalとconstの違い
    // ・final は、実行時定数であり、実行時に一度だけ値が設定され、その後変更する必要がない場合に使用されます
    // 　final は「実行時に確定する値」に使う
    // ・const は、コンパイル時定数であり、コンパイル時に値が決定する場合に使用されます
    // 　const は「完全に不変な値」にしか使えない
    // 　const は コンパイル時に決まる ので、メモリ効率が良くなる
    // Flutter/Dart では、ウィジェットのプロパティなど、実行時に値が決定する場面が多いため、final が頻繁に使用されます
    //
    // theme.textTheme：アプリのフォントテーマにアクセス
    // displayMedium：ディスプレイ テキスト用の大きなスタイル
    // ※displayは「ディスプレイ スタイルは短く、重要なテキストにのみ使用します」
    //
    // ! 演算子:Dartはnull になる可能性のあるオブジェクトのメソッドは呼び出せません
    // 　　　　　! 演算子（感嘆符演算子）を使い、承知のうえで行っているということを Dart に対して通知
    //
    // copyWith() ：定義した変更が反映されたテキスト スタイルのコピーが返されます
    // 　　　　　　　　この場合は、テキストの色のみを変更しています
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      // テーマデータから取得した色を設定
      // MyApp までスクロールし、そこで ColorScheme のシード色を変更すると、
      // この色とアプリ全体のカラーパターンを変更できます
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        // Text ウィジェットは pair.asLowerCase をそのまま表示
        child: Text(
            pair.asLowerCase,
            style: style,
            // スクリーンリーダーが読み上げる内容をカスタマイズ
            semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}