  //=============================================================================
//  START of giver code (copy the below code you wrote into the specification)
//=============================================================================

struct Challenge Tutorial = {
  .gaming = tutorial,
  .setup_pin = setup_tutorial,
  .time_limit = 90,
};

// giver pin assgin
const uint8_t GRAY_WIRE = 23;   // 灰色のワイヤが刺さっている 23 番
const uint8_t BROWN_WIRE = 21;  // 茶色のワイヤが刺さっている 21 番
const uint8_t PURPLE_WIRE = 18;  // 紫色のワイヤが刺さっている 18 番

void setup_tutorial(void) {
  pinMode(GRAY_WIRE, INPUT_PULLDOWN);
  pinMode(BROWN_WIRE, INPUT_PULLDOWN);
  pinMode(PURPLE_WIRE, INPUT_PULLDOWN);
}

void tutorial(void *pvParameters) {
  // 最初はどっちも false
  bool flag1 = false;
  bool flag2 = false;
  bool flag3 = false;

  while (1) {
    flag1 = digitalRead(GRAY_WIRE) == LOW;
    flag2 = digitalRead(BROWN_WIRE) == LOW;
    flag3 = digitalRead(PURPLE_WIRE) == LOW;

    // もし，flag1 が true なら { } の中へ
    if (flag1 && flag3) {
      succeeded();  // 解除成功！
    }

    // もし，flag2 が true なら { } の中へ
    if (flag2) {
      failed();  // 解除失敗……
    }
  }
}

//=============================================================================
//  END of giver code
//=============================================================================
