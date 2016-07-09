準備
----

$ gem install selenium-webdriver

chromedriverをインストール
http://chromedriver.storage.googleapis.com/index.html
から最新版をダウンロードしてパスの通ったところに置く

登録番号と暗証番号のcsvファイルを用意する
    12234,4321,平岡,モンスターズ

手動でアクセスして候補の日時を選ぶ

実行
----
候補の日時からコマンドを作成する

    $ ruby hunter.rb 6:0 > batch.sh

バッチを実行する

    $ sh batch.sh


Known Issues
------------
Macだと大量のchromeがdockに残る
