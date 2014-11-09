Rakufun

RakufunはObjective-cの関数宣言や関数定義の作成をサポートするプラグインです。

# 対象

Xcode with Objective-C

# インストール方法

Rakufunをダウンロードして、Xcodeにてコンパイルして、Xcodeを再起動してください。
動作確認は、Xcode Version6.1で行っています。

デフォルトで、CTRL+mにショートカットキーが割り当てられるので、
必要に応じてRakufunPlugin.mのDEFAULT_KEYの値を変更してください。

# アンインストール方法

~/Library/Application Support/Developer/Shared/Xcode/Plug-ins/にあるRakufun.xcplugin/を削除します。

# 使い方

![rakufun.gif](Screenshots/rakufun.gif)

## 関数宣言の生成

ソースファイル(m, mm)の関数定義文で、CTRL+mを行うと、ヘッダーファイルにその関数の
関数宣言を作成します。

```objc
A.m
-(void)foo { // この行でCTRL+mを実行する
             // この行でCTRL+mを実行してもOK.
}

A.h

@interface A

-(void)foo; // これを自動生成する
@end
```

## 関数定義の生成

ヘッダーファイル(h)の関数宣言で、CTRL+mを行うと、ソースファイル(m)にその関数の
関数定義を作成します。

```objc
A.h

@interface A
-(void)foo; // この行でCTRL+mを実行する
@end

A.m

-(void)foo {  // @endの直前に、これを自動生成する。
}
@end

`

# 注意点

- クラス名はファイル名から推測するため、大文字小文字を含めて一致している必要があります。
- カテゴリのファイル名は、classname+categorynameを前提として扱います。
- 関数外から実行すると、カーソル位置から探索して、一番最初にマッチしたシグネチャに対して自動生成します。


# 課題

- 構文解析が貧弱なのでできれば強化したい。
- 複数の関数を処理できるようにしたい。
- 関数外から実行した場合は処理をしないようにする。
- プロパティを任意の位置から生成したい。