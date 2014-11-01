Rakufun

Rakufunはソースファイル(.mまたは.mm)の関数定義から、簡単にヘッダーファイルに関数宣言を記述するプラグインです。

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

ソースファイル(m, mm)の関数定義文で、CTRL+mを行うと、ヘッダーファイルにその関数の
関数宣言を作成します。

```objc
A.m
-(void)foo { // この行で、CTRL+mを実行する
            // 関数の定義内で、CTRL+mをしても反応しません。
}

A.h

@interface A

-(void)foo; // これを自動生成する
@end
```


# 注意点

- 現状ではシグネチャが一行の場合のみ動作します。
- クラス名はファイル名から推測するため、大文字小文字を含めて一致している必要があります。
- カテゴリのファイル名は、classname+categorynameを前提として扱います。


# 課題

- シグネチャが複数行にまたがる場合正しく動作しない。
- 構文解析が貧弱なのでできれば強化したい。
- 複数の関数を処理できるようにしたい。
- ヘッダーファイルから定義を生成したい。