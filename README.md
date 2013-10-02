blowing-in-tweets
=================

* はじめに

twitter のタイムラインの流量に合わせて、PCに接続された Arduino 経由で制御された PCファン が回転します。
タイムラインの流れが早ければ早いほど、風量が強くなります。
tweetが押し寄せるさまを物理的に感じることのできる「まさにフィジカルコンピューティング」なアプリケーションです。


* 使い方

プロジェクトをcloneする

    $ git clone https://github.com/junpeitsuji/blowing-in-tweets

dev.twitter.com からアクセストークンを取得し、 processing_blowing_in_tweets/accesskeys.json を下記の書式で追加

    {
    	"consumerKey": "********",
    	"consumerSecret": "********",
    	"accessToken": "********",
    	"accessSecret": "********"
    }

[このサイト](https://docs.google.com/file/d/0BzyVHU69QO3mbVdxUGZsVE4yUFk/edit?usp=drive_web)から twitter4j for processing をダウンロードし、展開したファイルをすべて blowing-in-tweets/processing_blowing_in_tweets/code 以下に配置

arduino_blowing_in_tweets.ino を開いて arduino に書き込む

arduino の digital 9 に モータードライバの in1, digital 10 に モータードライバの in2 を接続。モータードライバは TA7291P がおすすめ。

PCファンにモータードライバの out1, out2 をそれぞれ接続する。

Arduino と PCを接続します。PCファンの大きさによっては、Arduino の電源ポートに外部電源が必要になります。

processing_blowing_in_tweets.pde を起動し、キーボードから「検索したいツイートのキーワード」を入力し、エンターを入力します。すると、ツイートが取得され、PCファンのモーターが連動して動くはずです。

tweetの風を浴びましょう。すずしー♪

