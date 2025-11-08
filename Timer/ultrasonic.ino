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
    pinMode(TRIG, OUTPUT);
    pinMode(LED1, OUTPUT);
    pinMode(LED2, OUTPUT);
    pinMode(LED3, OUTPUT);
    pinMode(LED4, OUTPUT);
    pinMode(LED5, OUTPUT);
    pinMode(ECHO, INPUT);
    pinMode(LEFT_BUTTON,  INPUT_PULLDOWN);
    pinMode(RIGHT_BUTTON, INPUT_PULLDOWN);
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

        duration = pulseIn(ECHO, HIGH);
        cm = (duration / 2) * 0.0344;

        digitalWrite(LED1, LOW);
        digitalWrite(LED2, LOW);
        digitalWrite(LED3, LOW);
        digitalWrite(LED4, LOW);
        digitalWrite(LED5, LOW);
        if (10 <= cm) {
          digitalWrite(LED1, HIGH);
        }
        if (15 <= cm) {
          digitalWrite(LED2, HIGH);
        }
        if (20 <= cm) {
          digitalWrite(LED3, HIGH);
        }
        if (25 <= cm) {
          digitalWrite(LED4, HIGH);
        }
        if (30 <= cm) {
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
    }
}
