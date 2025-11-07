struct Challenge Distance = {
    .gaming = distance,
    .setup_pin = setup_dist,
    .time_limit = 900,
};

// giver pin assgin
const uint8_t TRIG = 16;
const uint8_t ECHO = 17;
const uint8_t LEFT_BUTTON = 15;
const uint8_t RIGHT_BUTTON = 19;

void setup_dist(void) {
    pinMode(TRIG,  OUTPUT);
    pinMode(ECHO, INPUT);
    pinMode(LEFT_BUTTON,  INPUT_PULLDOWN);
    pinMode(RIGHT_BUTTON, INPUT_PULLDOWN);
}

void distance(void *pvParameters) {
    bool flag1 = false;
    bool flag2 = false;
    bool flag3 = false;
    long duration, cm;

    digitalWrite(TRIG, LOW);
    delayMicroseconds(5);
    digitalWrite(TRIG, HIGH);
    delayMicroseconds(10);
    digitalWrite(TRIG, LOW);

    while(1) {
        flag1 = (digitalRead(RIGHT_BUTTON)  == HIGH);
        flag2 = (digitalRead(LEFT_BUTTON) == HIGH);

        duration = pulseIn(ECHO, HIGH);
        cm = (duration/2) / 29.1;

        if (flag1 && 7 < cm && cm < 11) {
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
    }
}

