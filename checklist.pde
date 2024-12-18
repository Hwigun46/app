class ChecklistWidget {
  PImage checklistBg; // 체크리스트 배경 이미지
  boolean[] checked;  // 체크 상태
  float[] yPositions; // 각 항목의 Y 좌표
  float xPosition;    // 항목의 X 좌표

  float x, y;         // 위젯의 기준 위치

  ChecklistWidget(float x, float y) {
    this.x = x;
    this.y = y;

    // 이미지 로드
    checklistBg = loadImage("data/image/checklist.png");

    // 체크 상태 초기화 (4개 항목)
    checked = new boolean[4];

    // 항목 좌표 설정
    xPosition = this.x + 121; // X 기준 (32 + 121)
    yPositions = new float[]{this.y + 13.75f, this.y + 50.25f, this.y + 87.25f, this.y + 123.75f}; // 각각의 Y 기준 (881에서 상대적으로 계산)
  }

  void display() {
    // 체크리스트 배경 이미지 출력
    image(checklistBg, x, y, 338, 158); // 배경 크기 피그마 값

    // 체크된 항목 출력
    for (int i = 0; i < 4; i++) {
      if (checked[i]) {
        // 빈 원 그리기 - 하늘색 채우기
        fill(89, 171, 225); // 하늘색 (RGB 값)
        noStroke();         // 외곽선 없음
        ellipse(xPosition + 11, yPositions[i] + 10.5f, 19.5f, 19.5f); // 원 중심(x, y), 크기(20x20)

        // 취소선 그리기 - 길이 155px
        stroke(100); // 회색
        line(xPosition + 29, yPositions[i] + 10, xPosition + 184, yPositions[i] + 10);
      }
    }
  }

  void handleMousePress(float mouseX, float mouseY, int scrollY) {
    // 스크롤 보정된 마우스 좌표
    float adjustedMouseY = mouseY + scrollY;

    // 각 원의 클릭 영역 확인
    for (int i = 0; i < 4; i++) {
      float d = dist(mouseX, adjustedMouseY, xPosition + 10, yPositions[i] + 10);

      if (d < 10) { // 원 반경 내 클릭 확인
        checked[i] = !checked[i]; // 상태 토글
      }
    }
  }
}