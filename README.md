# phoneticGuidesApp ~ ふりがな(ルビ)ガイドアプリ ~

漢字の文章を全て平仮名に変換し表示してくれるアプリ．  


## Arcitecture アーキテクチャ

- MVVM

※1の記事を参考に作成


## Requirements 必要事項
このアプリでは以下の条件下で動作を確認しています．

- Xcode: 11.4 
- iOS: 13
- Swift: 5.0  

また、このアプリではCocoaPodsを使用してるため、それらをインストールする必要があります．  

**cocoapodsのインストール**

```
sudo gem install cocoapods
```

**ライブラリの追加**  
プロジェクトのルートで以下のコマンドを実行
```
pod install
```

### APIキーの取得
本アプリでは、[gooラボのAPI](https://labs.goo.ne.jp/api/jp/hiragana-translation/)を利用しています．　  
そのため、事前にgooラボAPI[利用登録](https://labs.goo.ne.jp/jp/apiregister/)をしAPIキー(アプリケーションID)を取得してください．

取得後、プロジェクト内のAPI_KEY.switf内の****の部分にAPIキー(アプリケーションID)貼り付けてください．
```
let API_KEY = "*******"
```



## Refanrences
**※1** OSをMVC,MVP,MVVM,Clean Architectureで実装してみた
 - https://medium.com/@rockname/clean-archirecture-7be37f34c943
 - https://github.com/rockname/ArchitectureSampleWithFirebase
 
**※2** goo ラボ　ひらがな化API
 - https://labs.goo.ne.jp/api/jp/hiragana-translation/
