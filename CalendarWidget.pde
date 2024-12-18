import java.util.HashMap;

class CalendarWidget {
  // 이미지 리소스
  PImage calendar;  // 기본 캘린더 이미지
  PImage arrowLeft, arrowRight;  // 좌우 화살표 토글 이미지
  PImage toggleDActive, toggleDInactive;  // 상단 주간 근무 토글
  PImage toggleEActive, toggleEInactive;  // 상단 야간 근무 토글
  PImage toggleNActive, toggleNInactive;  // 상단 심야 근무 토글


// 위치정보
  float x, y;


  // 토글 상태
  boolean isDActive = false;
  boolean isEActive = false;
  boolean isNActive = false;

  // 간호사 이름
  String[] nurses = {"나", "김간호사", "박간호사"};
  int currentNurse = 0; // 0부터 인덱스

  // 간호사별 근무 날짜
  HashMap<String, int[]> dDatesMap = new HashMap<>();
  HashMap<String, int[]> eDatesMap = new HashMap<>();
  HashMap<String, int[]> nDatesMap = new HashMap<>();

  // 날짜 위치 계산용
  float startX;  // 달력에서 1의 x 좌표
  float startY;  // 달력에서 1의 y 좌표
  float gapX;  // 각 날짜 별 x 좌표 간격
  float gapY;  // 각 날짜 별 y 좌표 간격
  int offset = 3;  // 행렬로 생각했을 때 숫자 1의 인덱스 위치

  CalendarWidget(float x, float y) {
    this.x = x;
    this.y = y;

    // 이미지 로드
    calendar = loadImage("data/image/Calender.png");
    arrowLeft = loadImage("data/image/arrow_left.png");
    arrowRight = loadImage("data/image/arrow_right.png");
    toggleDActive = loadImage("data/image/toggle_d_active.png");
    toggleDInactive = loadImage("data/image/toggle_d_inactive.png");
    toggleEActive = loadImage("data/image/toggle_e_active.png");
    toggleEInactive = loadImage("data/image/toggle_e_inactive.png");
    toggleNActive = loadImage("data/image/toggle_n_active.png");
    toggleNInactive = loadImage("data/image/toggle_n_inactive.png");

    // 날짜 위치 초기화
    startX = x + 37.3;
    startY = y + 136.5;
    gapX = 44.33;
    gapY = 46;

    // 간호사별 근무 날짜 초기화
    dDatesMap.put("나", new int[]{1, 2, 3, 5, 12, 19, 25, 27, 31});
    eDatesMap.put("나", new int[]{6, 7, 15, 16, 17});
    nDatesMap.put("나", new int[]{4, 8, 10, 22, 24, 30});

    dDatesMap.put("김간호사", new int[]{2, 3, 8, 14, 20, 25});
    eDatesMap.put("김간호사", new int[]{1, 5, 11, 18, 23});
    nDatesMap.put("김간호사", new int[]{6, 7, 15, 27, 29});

    dDatesMap.put("박간호사", new int[]{4, 9, 13, 21, 26, 30});
    eDatesMap.put("박간호사", new int[]{3, 10, 19, 24, 28});
    nDatesMap.put("박간호사", new int[]{5, 11, 16, 22, 31});
  }

  void display() {
    // 달력 배경 출력
    image(calendar, x, y, 338, 504);

    // 화살표 버튼 출력
    image(arrowLeft, x + 230.76, y + 59.6, 10, 17);
    image(arrowRight, x + 305.79, y + 59.6, 10, 17);

    // 간호사 이름 출력
    float textX = x + (230.76 + 305.79) / 2 + 4.2;
    float textY = y + 59.6 + 8;
    textSize(10);
    fill(0); //텍스트 색상 검정색
    textAlign(CENTER, CENTER);  // 텍스트 중앙 정렬
    text(nurses[currentNurse], textX, textY); // 출력할 간호사 이름 (간호사 리스트[인덱스])

    // 각 근무별 토글 버튼 출력
    displayToggles();

    // 각 근무마다 맞는 색깔 동그라미 표시
    displayShiftCircles();
  }

  void displayToggles() {
    // 나를 제외한 나머지 간호사는 active 토글 출력
    // 만약 토글 active가 되었을 시도 actvie 토글 출력
    if (isDActive || currentNurse != 0) {
      image(toggleDActive, x + 160, y + 20, 40, 20);
    } else {
      image(toggleDInactive, x + 160, y + 20, 40, 20);
    }

    if (isEActive || currentNurse != 0) {
      image(toggleEActive, x + 215, y + 20, 40, 20);
    } else {
      image(toggleEInactive, x + 215, y + 20, 40, 20);
    }

    if (isNActive || currentNurse != 0) {
      image(toggleNActive, x + 270, y + 20, 40, 20);
    } else {
      image(toggleNInactive, x + 270, y + 20, 40, 20);
    }
  }

  void displayShiftCircles() {
    // 현재 출력되는 간호사 이름 확인
    String nurseName = nurses[currentNurse];

    if (currentNurse == 0) {  // '나'는 토글 active에 따라 표시
      if (isDActive) drawShiftCircles(dDatesMap.get(nurseName), "D");
      if (isEActive) drawShiftCircles(eDatesMap.get(nurseName), "E");
      if (isNActive) drawShiftCircles(nDatesMap.get(nurseName), "N");
    } else {  // 다른 간호사 (모든 근무 표시)
      drawShiftCircles(dDatesMap.get(nurseName), "D");
      drawShiftCircles(eDatesMap.get(nurseName), "E");
      drawShiftCircles(nDatesMap.get(nurseName), "N");
    }
  }

  void drawShiftCircles(int[] dates, String shiftType) {
    for (int date : dates) {
      // 각 날짜 별 위치 좌표 계산 후 해당 좌표 + 근무 타입에 맞춰 동그라미 표시
      float[] pos = calculateDatePosition(date);
      drawShiftCircle(pos[0], pos[1], shiftType);
    }
  }

  void drawShiftCircle(float x, float y, String shiftType) {
    // 색상 설정
    if (shiftType.equals("D")) {
      fill(0xcc, 0xee, 0xcc, 160);  
    } else if (shiftType.equals("E")) {
      fill(0xee, 0xcc, 0xcc, 160);  
    } else if (shiftType.equals("N")) {
      fill(0xcc, 0xcc, 0xee, 160);  
    }
    noStroke(); // 원 외곽선 제거
    ellipse(x, y, 35, 35);  // 원 크기 설정
  }

  float[] calculateDatePosition(int date) {
    int col = (offset + date - 1) % 7;  // 열 계산  (x 좌표)
    int row = (offset + date - 1) / 7;  // 행 계산  (y 좌표)

    float posX = startX + col * gapX; // 시작(1) 위치에 해당 날짜 열 값 보정
    float posY = startY + row * gapY; // 시작(1) 위치에 해당 날짜 행 값 보정

    return new float[]{posX, posY}; // 보정된 값 반환
  }

  void toggleButtons(float mouseX, float mouseY, int scrollY) {
    float adjustedMouseY = mouseY + scrollY;
    if (mouseX > x + 160 && mouseX < x + 200 && adjustedMouseY > y + 20 && adjustedMouseY < y + 40) {
      isDActive = !isDActive;
    }
    if (mouseX > x + 215 && mouseX < x + 255 && adjustedMouseY > y + 20 && adjustedMouseY < y + 40) {
      isEActive = !isEActive;
    }
    if (mouseX > x + 270 && mouseX < x + 310 && adjustedMouseY > y + 20 && adjustedMouseY < y + 40) {
      isNActive = !isNActive;
    }
  }

  void handleArrows(float mouseX, float mouseY, int scrollY) {
    float adjustedMouseY = mouseY + scrollY;
    if (mouseX > x + 230.76 && mouseX < x + 240.76 && adjustedMouseY > y + 59.6 && adjustedMouseY < y + 76.6) {
      currentNurse = (currentNurse - 1 + nurses.length) % nurses.length;
    }
    if (mouseX > x + 305.79 && mouseX < x + 315.79 && adjustedMouseY > y + 59.6 && adjustedMouseY < y + 76.6) {
      currentNurse = (currentNurse + 1) % nurses.length;
    }
  }
}