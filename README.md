Rakufun

Rakufunはソースファイル(.mまたは.mm)の関数定義から、簡単にヘッダーファイルに関数宣言を記述するプラグインです。

# 対象

Xcode with Objective-C

# インストール方法

Rakufunをダウンロードして、Xcodeにてコンパイルして、Xcodeを再起動してください。
動作確認は、Xcode Version6.1で行っています。

デフォルトで、CTRL+mにショートカットキーが割り当てられるので、
必要に応じてRakufunPlugin.mのDEFAULT_KEYの値を変更してください。

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

- クラス名はファイル名から推測するため、大文字小文字を含めて一致している必要があります。
- カテゴリのファイル名は、classname+categorynameを前提として扱います。
