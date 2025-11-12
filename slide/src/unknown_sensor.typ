= 問題2: unknown sensor
== 配線図
#figure(
    image("../images/unknown_sensor.pdf", width: 75%),
    //caption: [競技に使う装置],
)

== プログラム
```c++
struct Challenge UnknownSensor = {
    .gaming = unknown_sensor,
    .setup_pin = setup_unknown,
    .time_limit = 900,
};

// giver pin assgin
const uint8_t SENSOR = 17;
const uint8_t LED_B = 18;
const uint8_t LED_G = 19;
const uint8_t BUTTON_LEFT = 15;
const uint8_t BUTTON_RIGHT = 23;

void setup_unknown(void) {
    pinMode(LED_B, OUTPUT); // LED を点灯させるためのピン
    pinMode(LED_G, OUTPUT); // LED を点灯させるためのピン
    pinMode(SENSOR, INPUT_PULLDOWN); // センサの値を読み取るピン
    pinMode(BUTTON_LEFT, INPUT_PULLDOWN); // ボタンの入力を読み取るピン
    pinMode(BUTTON_RIGHT, INPUT_PULLDOWN); // ボタンの入力を読み取るピン
}

void unknown_sensor(void *pvParameters) {
    // 最初は全部 false
    bool flag1 = false;
    bool flag2 = false;
    bool flag3 = false;

    while(1) {
        // BUTTON_LEFT 番のピンが HIGH なら true そうでなければ false
        flag1 = (digitalRead(BUTTON_LEFT)  == HIGH);

        // BUTTON_RIGHT 番のピンが HIGH なら true そうでなければ false
        flag2 = (digitalRead(BUTTON_RIGHT)  == HIGH);

        // SENSOR 番のピンが HIGH なら true そうでなければ false
        flag3 = (digitalRead(SENSOR) == LOW);

        // もし，flag1 の中身が true だったら { } の中へ
        if (flag1) {
          digitalWrite(LED_G, HIGH);
        // そうじゃなかったら↓の { } の中へ
        } else {
          digitalWrite(LED_G, LOW);

        }

        // もし，flag3 の中身が true だったら { } の中へ
        if (flag3) {
          digitalWrite(LED_B, HIGH);
        // そうじゃなかったら↓の { } の中へ
        } else {
          digitalWrite(LED_B, LOW);

        }

        // もし，flag3 と flag2 の*両方*が true なら
        if(flag3 && flag2) {
            succeeded();
        }

        // もし，flag3 と flag1 の*両方*が true なら
        if(flag3 && flag1) {
            failed();
        }

        delay(100);
    }
}

```
== 解説
