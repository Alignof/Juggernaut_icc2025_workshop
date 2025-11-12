//=============================================================================
//  START of giver code (copy the below code you wrote into the specification)
//=============================================================================

struct Challenge RedOrBlue = {
  .gaming = red_or_blue,
  .setup_pin = setup_rob,
  .time_limit = 600,  // 600 秒 = 10 分
};

// giver pin assgin
const uint8_t RED_WIRE = 23;   // 赤いワイヤが刺さっている 23 番
const uint8_t BLUE_WIRE = 18;  // 青いワイヤが刺さっている 18 番

void setup_rob(void) {
  pinMode(RED_WIRE, INPUT_PULLDOWN);  // Vcc(+) に繋がってたら HIGH それ以外は LOW
  pinMode(BLUE_WIRE, INPUT_PULLDOWN);
}

void red_or_blue(void *pvParameters) {
  // 最初はどっちも false
  bool flag1 = false;
  bool flag2 = false;

  while (1) {
    // もし，RED_WIRE 番のピンが LOW だったら { } の中へ
    if (digitalRead(RED_WIRE) == LOW) {
      flag1 = true;
      // そうじゃなかったら↓の { } の中へ
    } else {
      flag1 = false;
    }

    // もし，BLUE_WIRE 番のピンが LOW だったら { } の中へ
    if (digitalRead(BLUE_WIRE) == LOW) {
      flag2 = true;
      // そうじゃなかったら↓の { } の中へ
    } else {
      flag2 = false;
    }

    // もし，flag1 が true なら { } の中へ
    if (flag1) {
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
