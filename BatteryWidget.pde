class BatteryWidget {
  float y;
  BatteryWidget(float y) {
    this.y = y;
  }
  void display() {
    fill(200);
    rect(20, 730, 360, 100, 10);
    fill(0);
    textAlign(LEFT);
    textSize(14);
    text("배터리 상태", 40, 760);
    // 여기에 배터리 상태 아이콘 그리기
    ellipse(80, 800, 20, 20);  // 배터리 아이콘 예시
  }
}