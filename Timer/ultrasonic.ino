struct Challenge Ultrasonic = {
    .gaming = ultrasonic,
    .setup_pin = setup_dist,
    .time_limit = 900,
};

// giver pin assgin
const uint8_t TRIG = 16;
const uint8_t ECHO = 17;
const uint8_t LED1 = 2;
const uint8_t LED2 = 4;
const uint8_t LED3 = 18;
const uint8_t LED4 = 19;
const uint8_t LED5 = 21;
const uint8_t LEFT_BUTTON = 15;
const uint8_t RIGHT_BUTTON = 23;

void setup_dist(void) {
    pinMode(TRIG, OUTPUT); // 出力のためのピン
    pinMode(LED1, OUTPUT); // 出力のためのピン
    pinMode(LED2, OUTPUT); // 出力のためのピン
    pinMode(LED3, OUTPUT); // 出力のためのピン
    pinMode(LED4, OUTPUT); // 出力のためのピン
    pinMode(LED5, OUTPUT); // 出力のためのピン
    pinMode(ECHO, INPUT);  // 入力のためのピン
    pinMode(LEFT_BUTTON,  INPUT_PULLDOWN); // ボタンの入力を読むためのピン
    pinMode(RIGHT_BUTTON, INPUT_PULLDOWN); // ボタンの入力を読むためのピン
}

void ultrasonic(void *pvParameters) {
    bool flag1 = false;
    bool flag2 = false;
    bool flag3 = false;
    float duration, cm;

    while(1) {
        flag1 = (digitalRead(RIGHT_BUTTON)  == HIGH);
        flag2 = (digitalRead(LEFT_BUTTON) == HIGH);

        digitalWrite(TRIG, LOW);
        delayMicroseconds(2);
        digitalWrite(TRIG, HIGH);
        delayMicroseconds(10);
        digitalWrite(TRIG, LOW);

        // ECHO が HIGH になっている時間を返す（マイクロ秒）．
        duration = pulseIn(ECHO, HIGH);
        // duration を 2 で割って係数 0.0344 をかける．
        // 係数 0.0344 は 331.5 * (0.61 * t) （t は摂氏温度，今回は20度と想定）の結果の単位を合わせたもの．
        // これは一般的に約 340 m/s と習う「あの」速さを温度に合わせて厳密に計算したものです．
        cm = (duration / 2) * 0.0344;

        // 先に LED1~LED5 までのピンを全部 LOW にしておく
        digitalWrite(LED1, LOW);
        digitalWrite(LED2, LOW);
        digitalWrite(LED3, LOW);
        digitalWrite(LED4, LOW);
        digitalWrite(LED5, LOW);
        if (10 <= cm) { // もし cm の値が 10 以下だったら
          digitalWrite(LED1, HIGH); // LED1 番のピンを HIGH に
        }
        if (15 <= cm) { // もし cm の値が 15 以下だったら
          digitalWrite(LED2, HIGH);
        }
        if (20 <= cm) { // もし cm の値が 20 以下だったら
          digitalWrite(LED3, HIGH);
        }
        if (25 <= cm) { // もし cm の値が 25 以下だったら
          digitalWrite(LED4, HIGH);
        }
        if (30 <= cm) { // もし cm の値が 30 以下だったら
          digitalWrite(LED5, HIGH);
        }
    
        if (flag1 && 15 < cm && cm <= 20) {
            flag3 = true;
        }
        
        // succeeded
        if(flag3) {
            succeeded();
        }

        // failed
        if(flag1 && flag2) {
            failed();
        }

        delay(100);
    } // while (true) { の行まで戻る
}
