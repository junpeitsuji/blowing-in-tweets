blowing-in-tweets
=================

* はじめに
twitter のタイムラインの流量に合わせて、PCに接続された Arduino 経由で制御された PCファン が回転するアプリケーションです。
tweetの流れが早ければ早いほど、風量が強くなります。
タイムラインの風を物理的に感じることのできるフィジカルコンピューティングアプリケーションです。


* 使い方

1. プロジェクトをcloneする

    $ git clone https://github.com/junpeitsuji/blowing-in-tweets

2. dev.twitter.com からアクセストークンを取得し、 processing_blowing_in_tweets/accesskeys.json を下記の書式で追加

    {
    	"consumerKey": "********",
    	"consumerSecret": "********",
    	"accessToken": "********",
    	"accessSecret": "********"
    }

3. twitter4j をダウンロードし、展開した.jarファイルをすべて blowing-in-tweets/processing_blowing_in_tweets/code 以下に配置

4. arduino_blowing_in_tweets.ino を開いて arduino に書き込む

5. arduino の digital 9 に モータードライバの in1, digital 10 に モータードライバの in2 を接続。モータードライバは TA7291P がおすすめ。

6. PCファンにモータードライバの out1, out2 をそれぞれ接続する。

7. Arduino と PCを接続します。PCファンの大きさによっては、Arduino の電源ポートに外部電源が必要になります。

8. processing_blowing_in_tweets.pde を起動し、キーボードから「検索したいツイートのキーワード」を入力し、エンターを入力します。すると、ツイートが取得され、PCファンのモーターが連動して動くはずです。

9. tweetの風を浴びましょう。すずしー♪

