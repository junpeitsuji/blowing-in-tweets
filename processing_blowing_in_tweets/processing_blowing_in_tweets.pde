import processing.serial.*;
import twitter4j.conf.*;
import twitter4j.internal.async.*;
import twitter4j.internal.org.json.*;
import twitter4j.internal.logging.*;
import twitter4j.http.*;
import twitter4j.internal.util.*;
import twitter4j.api.*;
import twitter4j.util.*;
import twitter4j.internal.http.*;
import twitter4j.*;


// objects for UI 
final int UI_STATE_INPUT = 0;
final int UI_STATE_TRACKING = 1;
int   uiState = UI_STATE_INPUT;
color bgColor = color(0, 0, 0);
int   uiFrame = 0;

// objects for serial communication with arduino 
Serial arduino;
String comPort = "";

// objects for Twitter Streaming API
TwitterStreamFactory factory;
String[] track = { "" };

// objects for visualization and motor control
int frame = 10;            // 1秒間当たりのフレーム数
int duration = frame * 10; // 1 tweet の効果持続 (10 秒間)
int power = 10;            // 1 tweet あたり 10 pt 加算
int frameBufferLength = frame * 100;
int[] frameBuffer = new int[frameBufferLength];

// objects for calculate tweets per sec
final int tweetsCountDuration = 10; // 10 秒間隔で計測
int   tweetsCount      = 0;
float tweetsPerSec     = 0.0;

void setup() {
  size(640, 640);
  frameRate(frame);
  
  try {
    if( Serial.list().length > 0 ) {
      comPort = Serial.list()[0];
      // comPort = "/dev/tty.usbmodem1421";  // for Mac
    
      arduino = new Serial(this, Serial.list()[0], 9600);
      arduino.bufferUntil('\n');
    
    }
    else {
      arduino = null;
    }
  } catch (Exception e) {
    arduino = null; 
  }

  // アクセストークンの設定
  Configuration config = getTwitterConfiguration("accesskeys.json");

  // TwitterStreamを生成
  factory = new TwitterStreamFactory(config);
  
}

void draw() {

  if(uiState == UI_STATE_TRACKING) {

    if(uiFrame % (frame * tweetsCountDuration) == 0 ){
      tweetsPerSec = tweetsCount / (float)tweetsCountDuration;
      tweetsCount = 0;
    }
    
    int value = frameBuffer[uiFrame % frameBufferLength];
    frameBuffer[uiFrame % frameBufferLength] = 0;
  
    if(value > 255)
      value = 255;
    else if(value < 0)
      value = 0;
    
    bgColor = color(0, 0, value);
    background(bgColor);
  
    try {
      if( arduino != null ){
        if(uiFrame % 10 == 0){
            arduino.write(value);
        }
      }
    } catch( Exception e ) {
      e.printStackTrace();
    }
    
    uiFrame++;
  }
  else if(uiState == UI_STATE_INPUT){
    bgColor = color(0, 0, 0);
    background(bgColor);    
  }

  fill(255);
  if( !comPort.equals("") ) {
    textAlign(RIGHT);
    textSize(24);
    text( "Connecting arduino port: " + comPort, 620, 620);
  }
  
  textAlign(LEFT);
  textSize(32);
  text( "Search results for", 120, 200);

  textAlign(CENTER);
  textSize(24);
  text( "tweets per second: " + tweetsPerSec , 320, 400);
  
  textAlign(CENTER);
  textSize(96);
  text( "\""+track[0]+"\"", 320, 320);

}

void mouseReleased() {
  
}

void startTracking() {
  for(int i=0; i<frameBufferLength; i++){
    frameBuffer[i] = 0;
  }

  TwitterStream twitterStream = factory.getInstance();
  
  // イベントを受け取るリスナーオブジェクトを設定
  twitterStream.addListener(new UserStreamAdapter() {

    @Override
    public void onStatus(Status status) {
      
      String screenname = status.getUser().getScreenName();
      Long userId = status.getUser().getId();
      String tweetBody = status.getText();
      tweetBody = tweetBody.replace("\r", "");
      tweetBody = tweetBody.replace("\n", "");
      tweetBody = tweetBody.replace("\t", "");

      System.out.println(screenname + " : " + userId + " : " + tweetBody );
      
      for(int i=0; i<duration; i++){
        int index = (i + uiFrame) % frameBufferLength;
        frameBuffer[index] += power;
      }
      
      tweetsCount++;
    }

    @Override
    public void onException(Exception ex)
    {
      ex.printStackTrace();
    }
    
  });
  
  FilterQuery query = new FilterQuery();
  query.track(track);
  // query.follow(list);
  twitterStream.filter(query);  // フィルターに合わせて収集する
  // twitterStream.user();   // oauthユーザーの情報のみ収集する
  // twitterStream.sample(); // ランダムにツイートを収集する
  
}

void keyPressed() {
  if( uiState == UI_STATE_INPUT ){
    if( key == '\n' ){
      uiState = UI_STATE_TRACKING;
      startTracking();
    } else {
      track[0] += key;
    }
  }
  if( key == ESC ){
    if(arduino != null) {
      arduino.write(0);  
    }
    super.exit();
  }
   
}

void exit() {
  //ここに終了処理
  if( arduino != null ) {
    arduino.write(0);  
  }
  super.exit();
}


Configuration getTwitterConfiguration(String jsonFileName) {
  processing.data.JSONObject json = loadJSONObject(jsonFileName);

  String consumerKey    = json.getString("consumerKey");
  String consumerSecret = json.getString("consumerSecret");
  String accessToken    = json.getString("accessToken");
  String accessSecret   = json.getString("accessSecret");
  
  ConfigurationBuilder config = new ConfigurationBuilder();
  config.setOAuthConsumerKey(consumerKey);
  config.setOAuthConsumerSecret(consumerSecret);
  config.setOAuthAccessToken(accessToken);
  config.setOAuthAccessTokenSecret(accessSecret);
  
  return config.build();
}


