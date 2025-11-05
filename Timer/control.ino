/*
 * @date		2025 11/05-
 * @code name	Juggernaut
 * @author		Takana Norimasa <Alignof@outlook.com>
 * @brief		Educational bomb disposal game
 * @repository	https://github.com/Alignof/Juggernaut
 */

const uint8_t DIGIT_CORON = 10;
const uint8_t DIGIT_NONE = 11;

bool timer_stop = true;
SignalColor signal_color = YELLOW;
EventGroupHandle_t eg_handle;

#define BIT_TIMER_FAILED (1 << 0)

volatile int time_remain = 0;
volatile int minits = 0;
volatile int second = 0;

// Timer
// ref: https://docs.espressif.com/projects/arduino-esp32/en/latest/api/timer.html
// ref: https://lang-ship.com/blog/work/esp32-timer/
hw_timer_t *timer = NULL;
portMUX_TYPE timerMux = portMUX_INITIALIZER_UNLOCKED;

// prototype declaration to prevent typedef error
void data_send(int digit, int num, SignalColor rgb);

// called every second.
void IRAM_ATTR onTimer() {
  BaseType_t xHigherPriorityTaskWoken = pdFALSE;
  if (!timer_stop) {
    digitalWrite(BUZZER, HIGH);

    portENTER_CRITICAL_ISR(&timerMux);
    time_remain--;
    if (time_remain <= 0) {
      timer_stop = true;
      minits = 0;
      second = 0;

      xEventGroupSetBitsFromISR(eg_handle, BIT_TIMER_FAILED, &xHigherPriorityTaskWoken);
    } else {
      minits = time_remain / 60;
      second = time_remain % 60;
    }
    portEXIT_CRITICAL_ISR(&timerMux);
    
    if (xHigherPriorityTaskWoken) {
      portYIELD_FROM_ISR();
    }
  }
}

void timeup_monitor(void *pvParameters) {
  while(1) {
    EventBits_t uxBits = xEventGroupWaitBits(
      eg_handle,
      BIT_TIMER_FAILED,
      pdTRUE,         
      pdFALSE,
      portMAX_DELAY
    );

    if (uxBits & BIT_TIMER_FAILED) {
      if (timer) {
        timerEnd(timer);
        timer = NULL;
      }
      
      failed(); 
    }
  }
}

void succeeded(void) {
  signal_color = GREEN;
  timer_stop = true;

  while (1) delay(1e5);
}

void failed(void) {
  signal_color = RED;
  timer_stop = true;

  digitalWrite(BUZZER, HIGH);
  delay(1200); // 1.2 s
  digitalWrite(BUZZER, LOW);
  while (1) delay(1e5);
}

void display(void *pvParameters) {
  timer_stop = false;
  minits = time_remain / 60;
  second = time_remain % 60;

  while (1) {
    if (!timer_stop) {
      digitalWrite(BUZZER, LOW);
    }
    data_send(4, (minits / 10) % 10, signal_color);
    data_send(3, minits % 10, signal_color);
    data_send(5, 10, signal_color);
    data_send(2, (second / 10) % 10, signal_color);
    data_send(1, second % 10, signal_color);
  }
}

void loop() {
  delay(1e5);
}

void setup() {
  int challenge_id = 0;
  struct Challenge *challenge = NULL;
  eg_handle = xEventGroupCreate();

  pinMode(SER, OUTPUT);
  pinMode(RCLK, OUTPUT);
  pinMode(SRCLK, OUTPUT);
  pinMode(BUZZER, OUTPUT);
  pinMode(SYSSW, INPUT);
  pinMode(SELECTSW, INPUT);

  // Use 1st timer of 4 (counted from zero).
  // Set 80 divider for prescaler (see ESP32 Technical Reference Manual for more
  // info).
  timer = timerBegin(1000000);
  
  // Attach onTimer function to our timer.
  timerAttachInterrupt(timer, &onTimer);
  
  // Set alarm to call onTimer function every second (value in microseconds).
  // Repeat the alarm (third parameter)
  timerAlarm(timer, 1000000, true, 0);

  data_send(5, DIGIT_NONE, YELLOW);
  data_send(1, challenge_id, YELLOW);

  // select challenge number
  while (digitalRead(SYSSW) == HIGH) {
    if (digitalRead(SELECTSW) == LOW) {
      challenge_id++;
      if (challenge_id == CHALLENGES_NUM) challenge_id = 0;

      data_send(1, challenge_id, YELLOW);

      delay(500);
    }
  };

  challenge = challenges[challenge_id];
  challenge->setup_pin();
  time_remain = challenge->time_limit;
  xTaskCreatePinnedToCore(challenge->gaming, "gaming", 8192, NULL, 1, NULL, 1);
  xTaskCreatePinnedToCore(display, "display", 8192, NULL, 1, NULL, 1);
  xTaskCreatePinnedToCore(timeup_monitor, "timeup_monitor", 2048, NULL, 1, NULL, 0);
  delay(100);
}

void data_send(int digit, int num, SignalColor rgb) {
  int i;
  uint16_t data;
  int seg[12] = {
    0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f,  // 0 - 9
    0x03, 0x00                                                   // coron, none
  };

  /*
	 *                QH <---------- QA
	 * register Left  :a,b,c,d,e,f,g,#,
	 * register Right :                R,Y,G,4,3,2,1,DP
	 */
  data = (1 << (digit + 10)) + (1 << (rgb + 8)) + (seg[num]);

  Serial.println(data, BIN);
  digitalWrite(RCLK, LOW);
  for (i = 0; i < DATASIZE; i++) {
    digitalWrite(SER, (data >> i) & 1);
    digitalWrite(SRCLK, LOW);
    digitalWrite(SRCLK, HIGH);
  }
  digitalWrite(RCLK, HIGH);
  delay(1);
}
