class VitalCheckWidget {
  int[] startTimes; // 타이머 시작 시간 배열
  boolean[] timerRunning; // 각 타이머 실행 상태
  int[] initialTimes; // 각 타이머 초기 시간

  PImage checkTimer; // 배경 이미지
  PFont font;

  float x, y; // 위젯 기준 위치

  VitalCheckWidget(float x, float y, PFont font) {
    this.x = x;
    this.y = y;
    this.font = font; // 전달받은 폰트를 사용

    // 타이머 초기화
    startTimes = new int[7];
    timerRunning = new boolean[7];
    initialTimes = new int[]{50 * 60 * 1000, 50 * 60 * 1000, 10 * 60 * 1000 + 30 * 1000, 5 * 60 * 1000 + 30 * 1000, 50 * 60 * 1000, 11 * 60 * 1000, 11 * 60 * 1000};

    checkTimer = loadImage("data/image/VitalCheck.png");

    for (int i = 0; i < startTimes.length; i++) {
      startTimes[i] = millis();
      timerRunning[i] = true;
    }

    textFont(this.font); // 전달받은 폰트를 텍스트에 적용
    textAlign(LEFT, CENTER);
  }

  void display() {
    // 배경 이미지 출력
    image(checkTimer, x, y, 158, 269);

    // 타이머 및 상태 원 출력
    for (int i = 0; i < initialTimes.length; i++) {
      float textX = x + 41.5f ;      // 병실 이름 텍스트 X 좌표
      float textY = y + 20.2 + i * 38; // 병실 이름 텍스트 Y 간격
      float timerX = x + 107.5;       // 타이머 X 좌표
      float timerY = y + 20.5 + i * 38; // 타이머 Y 좌표 동일
      float circleX = x + 139f;  // 타이머 기준 8.5픽셀 오른쪽에 원
      float circleY = y + 21 + i * 38; // 원의 Y 좌표 동일

      drawText(textX, textY, "병실:이름"); // 병실 이름 출력
      drawTimer(timerX, timerY, i);        // 타이머 출력
      drawCircle(circleX, circleY, i);     // 상태 원 출력
    }
  }

  void drawText(float x, float y, String text) {
    textSize(15); // 텍스트 크기 15 포인트로 설정
    fill(0);      // 텍스트 색상 설정
    text(text, x, y); // 병실 이름 출력
  }

  void drawTimer(float x, float y, int index) {
    int remainingTime = 0;
    if (timerRunning[index]) {
      int elapsedTime = millis() - startTimes[index];
      remainingTime = initialTimes[index] - elapsedTime;

      if (remainingTime <= 0) {
        remainingTime = 0; // 0으로 고정
        timerRunning[index] = false;
      }
    }

    int minutes = remainingTime / (60 * 1000);
    int seconds = (remainingTime / 1000) % 60;

    String timeDisplay = nf(minutes, 2) + ":" + nf(seconds, 2);

    textSize(15); // 타이머 텍스트 크기 동일
    fill(0);
    text(timeDisplay, x, y); // 타이머 위치 출력
  }

  void drawCircle(float x, float y, int index) {
    int remainingTime = 0;
    if (timerRunning[index]) {
      int elapsedTime = millis() - startTimes[index];
      remainingTime = initialTimes[index] - elapsedTime;

      if (remainingTime <= 0) {
        remainingTime = 0; // 0으로 고정
        timerRunning[index] = false;
      }
    }

    color circleColor = getColorBasedOnTime(remainingTime);
    noStroke();
    fill(circleColor);
    ellipse(x, y, 10, 10); // 원 위치와 크기
  }

  color getColorBasedOnTime(int remainingTime) {
    if (remainingTime > 10 * 60 * 1000) {
      return color(122, 204, 121); // 초록색
    } else if (remainingTime > 5 * 60 * 1000) {
      return color(247, 206, 70); // 노란색
    } else {
      return color(235, 78, 61); // 빨간색
    }
  }
}