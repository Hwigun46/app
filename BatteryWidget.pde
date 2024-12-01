class BatteryWidget {
  PImage batground;
  PImage[] icons; // 각 아이템의 아이콘 (핸드폰, 에어팟 등)
  PImage[] batteryImages; // 배터리 상태 이미지 (100, 20, 10)
  String[] names = {"phone", "airpot", "applewatch", "apcase"}; // 아이템 이름
  int[] batteryStates; // 배터리 상태
  float x, y; // 위젯 위치
  float[] iconPositionsX, iconPositionsY; // 아이콘 고정 X, Y 좌표

  BatteryWidget(float x, float y) {
    this.x = x;
    this.y = y; // 1058 기준으로 설정
    batteryStates = new int[]{100, 100, 100, 100};
    icons = new PImage[4];
    batteryImages = new PImage[3];
    
    // 아이콘과 버튼 고정 위치
    iconPositionsX = new float[]{x + 26, x + 98, x + 26, x + 98}; // 첫 열, 두 번째 열 X 위치
    iconPositionsY = new float[]{y + 26, y + 26, y + 98, y + 98}; // 첫 행, 두 번째 행 Y 위치

    // 이미지 로드
    batground = loadImage("data/image/battery_background.png");
    icons[0] = loadImage("data/image/phone.png");
    icons[1] = loadImage("data/image/airpod.png");
    icons[2] = loadImage("data/image/applewatch.png");
    icons[3] = loadImage("data/image/airpod_case.png");
    batteryImages[0] = loadImage("data/image/battery_100.png");
    batteryImages[1] = loadImage("data/image/battery_20.png");
    batteryImages[2] = loadImage("data/image/battery_10.png");

    for (int i = 0; i < batteryImages.length; i++) {
      batteryImages[i].resize(62, 62); // 배터리 이미지는 항상 62x62
    }
  }

  void display() {
    
    tint(255,180);
    // 배경 이미지 출력
    image(batground, x, y, 158, 158);
    noTint();

    // 아이콘과 버튼 출력
    for (int i = 0; i < icons.length; i++) {
      displayBatteryState(i); // 배터리 상태 먼저 출력 (뒤 배경으로)
      image(icons[i], iconPositionsX[i], iconPositionsY[i], 34, 34); // 아이콘 출력
    }
  }

  void displayBatteryState(int index) {
    PImage img = batteryStates[index] == 100 ? batteryImages[0] :
                 batteryStates[index] == 20 ? batteryImages[1] : batteryImages[2];
                 
    // 배터리 이미지를 아이콘 중심에 배치
    float batteryX = iconPositionsX[index] - (62 - 34) / 2; // 중심 정렬
    float batteryY = iconPositionsY[index] - (62 - 34) / 2; // 중심 정렬
    image(img, batteryX, batteryY, 62, 62); // 배터리 이미지 출력
  }

  void handleClick(float mouseX, float mouseY) {
    for (int i = 0; i < iconPositionsX.length; i++) {
      if (isMouseOverButton(mouseX, mouseY, i)) {
        toggleBatteryState(i);
      }
    }
  }

  boolean isMouseOverButton(float mouseX, float mouseY, int index) {
    // 배터리 상태 이미지 영역 클릭 처리
    float batteryX = iconPositionsX[index] - (62 - 34) / 2; // 중심 정렬
    float batteryY = iconPositionsY[index] - (62 - 34) / 2; // 중심 정렬
    return mouseX >= batteryX && mouseX <= batteryX + 62 &&
           mouseY >= batteryY && mouseY <= batteryY + 62;
  }

  void toggleBatteryState(int index) {
    batteryStates[index] = batteryStates[index] == 100 ? 20 :
                           batteryStates[index] == 20 ? 10 : 100;
  }
}