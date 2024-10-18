class CalendarWidget {
  float y;  // Y 좌표를 저장

  CalendarWidget(float y) {
    this.y = y;  // 생성자에서 Y 좌표를 받음
  }

  void display() {
    fill(0);
    textAlign(CENTER);
    textSize(20);
    text("2024년 10월", width / 2, y + 60);  // y 좌표를 사용

    // 요일 라벨
    textSize(14);
    String[] days = {"SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"};
    for (int i = 0; i < days.length; i++) {
      text(days[i], 60 + i * 45, y + 100);  // y 좌표를 사용
    }

    // 달력 날짜
    textSize(16);
    int startDay = 6;  // 시작 요일 (토요일)
    int day = 1;
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 7; j++) {
        if (i == 0 && j < startDay) {
          continue;
        }
        text(day, 60 + j * 45, y + 130 + i * 40);  // y 좌표를 사용
        day++;
        if (day > 31) {
          return;
        }
      }
    }
  }
}