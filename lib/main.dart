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
        title: 'Name App',
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

// アプリが機能するために必要となるデータを状態管理(リアクティブな値）で定義します
class MyAppState extends ChangeNotifier {
  // ランダムな単語のペアを収めた変数
  var current = WordPair.random();

  // current に新しいランダムな WordPair を再代入します
  void getNext() {
    current = WordPair.random();
    // 監視している MyAppState に通知するために notifyListeners()（ChangeNotifier) のメソッド）の呼び出しも行います。
    notifyListeners();
  }

  // このプロパティは空のリスト [] で初期化されています
  // <>(ジェネリクス)を使って、このリストが <WordPair>[] のみを含むように指定
  // これにより、WordPair 以外を追加しようとすると、Dart によりアプリの実行すら拒否されるようになります
  // favorites リストに望ましくないオブジェクト（null など）が入らなくなる

  // 注意
  // Dart には List（[] で表記）以外にもコレクション型があります
  // お気に入りのコレクションには Set（{} で表記）のほうが理にかなっているとも言えます
  //
  // 多分こんな違いらしい
  // List<WordPair>＝<WordPair>[] を使うと、同じ単語を複数回追加できてしまう → 望ましくない
  // Set<WordPair>＝<WordPair>{} を使えば、自動的に重複を防いでくれる → 便利！
  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);// すでにお気に入りなら削除
    } else {
      favorites.add(current);// まだお気に入りでなければ追加
    }
    // notifyListeners() は ChangeNotifier を継承したクラス で使われるメソッド
    // データの変更をリスナー（UIなど）に通知 するためのもの
    notifyListeners();
  }

}

// StatefulWidget+serStateパターンの状態管理を作成
//
// 書き方
// ClassName StatefulWidgetクラスを定義（class MyHomePage extends StatefulWidget）
// ↓
// _ClassName Stateクラスを定義（class _MyHomePageState extends State<MyHomePage>）
// ※ここまではAndoroid Studioでクラス名を右クリック→コンテキストアクションの表示→Convert to StatefulWidgetをクリックで自動で雛形を作れる
// ↓
//_ClassName Stateクラスに変数定義し、setState()で状態管理ができる
class MyHomePage extends StatefulWidget {
  // 警告：Constructors for public widgets should have a named 'key' parameter.が出てたので追加
  // FlutterのLintルール（コード品質のルール） のひとつで、公開クラス（外部から使われるWidget）にはkeyパラメータを明示的に定義するべきというルール
  const MyHomePage({super.key});

  @override
  // 中身を記載した_ClassNameのStateクラスを呼び出す
  State<MyHomePage> createState() => _MyHomePageState();
}

// ClassName StatefulWidgetの中身を_ClassName Stateに書く
class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    // Flutterの変数って？
    // var 変数名：型推論
    // 型名 変数名：Widget page; のように、初期化時に値が代入されない場合は、明示的に型を指定する必要があります。
    //
    // ※Dartでも出来るだけ型定義しながら書くらしい。

    // ページを切り替えるためのウィジェット変数
    Widget page;
    switch (selectedIndex) {
      case 0:
        // class GeneratorPageを表示
        page = GeneratorPage();
        break;
      case 1:
        // お気に入りリストFavoritesPageを表示
        page = FavoritesPage();
        break;
      // selectedIndex が 0 でも 1 でもない場合にエラーをスロー
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // Scaffold：親要素。各ページに一つ使う
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          // 横並びのレイアウト
          body: Row(
            children: [
              // スマホのノッチ（切り欠き）やステータスバー、ナビゲーションバーにコンテンツが重ならないようにするためのウィジェット
              SafeArea(
                //　画面の左側に縦に並ぶメニュー（ナビゲーションバー）を作るためのウィジェット
                child: NavigationRail(
                  // false の行は true に変更できます
                  // constraints.maxWidth >= 600でラベル表示を切り替える幅の設定ができます
                  // そうすることで、アイコンの隣のラベルが表示されます
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    // 1つのメニュー項目（ボタン）を表すウィジェット
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  // メニューのデフォルトの選択肢を最初にする
                  selectedIndex: selectedIndex,
                  // ナビゲーションメニュー（NavigationRail）のボタンが押されたときに呼ばれる処理を定義
                  onDestinationSelected: (value) {
                    // StatefulWidgetなのでsteStateが使え、状態管理で状態が変わるとUIも自動で再描画される
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              // Expanded ウィジェットは Row や Column で使用すると非常に便利
              // RowやColumnの中で「空いてるスペースをめいっぱい使いたい」ウィジェットに使うラッパー
              //
              // これを使用すると、ある子は必要なだけのスペースを埋め（この場合は NavigationRail）
              // 別のウィジェットは残りのスペースをできる限り埋める（この場合は Expanded）
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class GeneratorPage extends StatelessWidget {
  // 警告：Constructors for public widgets should have a named 'key' parameter.が出てたので追加
  // FlutterのLintルール（コード品質のルール） のひとつで、公開クラス（外部から使われるWidget）にはkeyパラメータを明示的に定義するべきというルール
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    // 全体の真ん中にレイアウト
    return Center(
      // 縦方向のレイアウト
      child: Column(
        // 子要素を中央配置
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          // 横方向のレイアウト
          Row(
            // ウィジェットのサイズを最小限にする
            mainAxisSize: MainAxisSize.min,
            children: [
              // イベントボタン
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              // SizedBox ウィジェットはスペースを埋めるだけで、それ自身は何もレンダリングしません
              // 視覚的な「ギャップ」を作るためによく利用されます。
              // SizedBox(width: 10)：横方向のすき間を作る（Rowの中で使う）
              // ちなみに・・SizedBox(height: 10)	：縦方向のすき間を作る（Columnの中で使う）
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // アプリの現在の状態を取得
    var appState = context.watch<MyAppState>();

    // お気に入りのリストが空の場合は、中央寄せされた「No favorites yet*.*」というメッセージを表示
    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    // ListViewでスクロール可能なリストを表示
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          // 概要を表示します（例: You have 5 favorites*.*）
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        // すべてのお気に入りについて反復処理を行い、それぞれに ListTile を構築
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
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