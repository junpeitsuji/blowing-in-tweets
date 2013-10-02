const int in1Pin = 9;
const int in2Pin = 10;

void forward(int value) {
  analogWrite(in1Pin, value);
  analogWrite(in2Pin, 0);  
}

void setup() {
  pinMode(in1Pin, OUTPUT);
  pinMode(in2Pin, OUTPUT);
  
  Serial.begin(9600);
}

void loop() {
  if( Serial.available() > 0 ) {
    int val = Serial.read();
    forward(val);
    Serial.println("f");
    delay(500);
  }
}

