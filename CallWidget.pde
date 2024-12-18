class CallWidget {
  float x, y; // CallWidget의 위치
  boolean doctorCalled = false; // 의사 콜 상태
  boolean transporterCalled = false; // 이송 요원 콜 상태
  PImage callground;
  PImage doctorButton, transporterButton;
  PImage doctorButtonCalled, transporterButtonCalled;
  PImage doctorCallPopUp, transportCallPopUp;

  // 팝업 상태
  boolean isPopupVisible = false;
  PImage currentPopupImage;
  Runnable currentOnConfirm;

  CallWidget(float x, float y) {
    this.x = x;
    this.y = y;

    // 이미지 로드
    callground = loadImage("data/image/widget_background.png");
    doctorButton = loadImage("data/image/doctor_call.png");
    transporterButton = loadImage("data/image/transport_call.png");
    doctorButtonCalled = loadImage("data/image/doctor_call_fin.png");
    transporterButtonCalled = loadImage("data/image/transport_call_fin.png");
    doctorCallPopUp = loadImage("data/image/doctor_call_popup.png");
    transportCallPopUp = loadImage("data/image/transport_call_popup.png");
  }

  void display() {
    tint(255, 180);
    image(callground, x, y, 158, 158);
    noTint();

    // 의사 콜 버튼
    image(doctorCalled ? doctorButtonCalled : doctorButton, x + 9, y + 16, 140, 68);
    // 이송 요원 콜 버튼
    image(transporterCalled ? transporterButtonCalled : transporterButton, x + 9, y + 78, 140, 68);

    // 팝업 표시
    if (isPopupVisible) {
      showPopup();
    }
  }

  void handleClick(float mouseX, float mouseY) {
  if (isPopupVisible) return; // 팝업이 이미 표시 중이면 클릭 무시
  
  // 의사 콜 버튼 클릭 시 호출 상태를 토글
  if (!isPopupVisible && mouseX > x + 9 && mouseX < x + 149 && mouseY > y + 16 && mouseY < y + 84) {
    if (!doctorCalled) {
      showPopup(doctorCallPopUp, () -> doctorCalled = true);
    } else {
      doctorCalled = false; // 호출된 상태면 취소
    }
  }

  // 이송 요원 콜 버튼 클릭 시 호출 상태를 토글
  if (!isPopupVisible && mouseX > x + 9 && mouseX < x + 149 && mouseY > y + 78 && mouseY < y + 146) {
    if (!transporterCalled) {
      showPopup(transportCallPopUp, () -> transporterCalled = true);
    } else {
      transporterCalled = false; // 호출된 상태면 취소
    }
  }
}

  void showPopup(PImage popupImage, Runnable onConfirm) {
  if (isPopupVisible) return; // 이미 팝업이 표시 중이면 무시

  isPopupVisible = true; // 팝업 상태 활성화
  currentPopupImage = popupImage;
  currentOnConfirm = onConfirm;
}

void showPopup() {
  // 블러 처리와 팝업 출력은 고정된 화면 좌표로 그리되, 스크롤 반영
  
  
  // 팝업 배경 블러 처리 (스크롤 상태에 맞게 전체 화면에 적용)
  fill(0, 0, 0, 150); 
  rect(0, scrollY, width, screenHeight); // 스크롤에 영향을 받지 않도록 화면 전체 처리

  // 팝업 이미지 출력 (현재 스크롤 위치를 반영해 중앙에 그리기)
  float popupX = (width - 270) / 2;                 // 가로 중앙
  float popupY = (screenHeight - 136.5) / 2 + scrollY;        // 세로 중앙 (스크롤 영향 없음)

  image(currentPopupImage, popupX, popupY, 270, 136.5);

  
}

  void handlePopupClick(float mouseX, float mouseY) {
    if (!isPopupVisible || currentPopupImage == null) return;

    float popupX = (width - 270) / 2;
    float popupY = (height - 136.5) / 2;

    // 버튼 영역
    float yesX = popupX, yesY = popupY + 92, yesWidth = 135, yesHeight = 44.5;
    float noX = yesX + yesWidth, noY = yesY;

    if (mouseX > yesX && mouseX < yesX + yesWidth && mouseY > yesY && mouseY < yesY + yesHeight) {
      if (currentOnConfirm != null) currentOnConfirm.run();
      closePopup();
    } else if (mouseX > noX && mouseX < noX + yesWidth && mouseY > noY && mouseY < noY + yesHeight) {
      closePopup();
    } else {
      // 팝업 외부 클릭 시 닫기
      closePopup();
    }
  }

  void closePopup() {
    isPopupVisible = false;
    currentPopupImage = null;
    currentOnConfirm = null;
  }
}