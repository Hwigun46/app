int scrollY = 0;  // 스크롤 위치
int screenHeight = 874;  // 아이폰 화면 크기
int contentHeight = 1461; // 전체 컨텐츠 길이

PImage backgroundImage;
PImage statusBar;

CalendarWidget calendarWidget;  // CalendarWidget 인스턴스
VitalCheckWidget vitalCheckWidget;  // VitalCheckWidget 인스턴스
ChecklistWidget checklistWidget; // ChecklistWidget 인스턴스
WalletWidget walletWidget;  // WalletWidget 인스턴스
BatteryWidget batteryWidget;  // BatteryWidget 인스턴스
PFont font; // 공통 폰트

void settings() {
  size(402, screenHeight);  // 화면 크기 설정
  backgroundImage = loadImage("data/image/blurScreen.png");
  statusBar = loadImage("data/image/statusbar.png");
}

void setup() {
  font = createFont("font/d2coding.ttf", 14);  // 공통 폰트 설정
  textFont(font);  // 기본 폰트로 설정

  calendarWidget = new CalendarWidget(32, 70);  // 캘린더 위치
  vitalCheckWidget = new VitalCheckWidget(32, 593, font);  // VitalCheck 위치 및 폰트 전달
  checklistWidget = new ChecklistWidget(32, 881); // Checklist 위치
  walletWidget = new WalletWidget(32, 1233); // Wallet 위치
  batteryWidget = new BatteryWidget(32, 1058); // BatteryWidget 위치
}

void draw() {
  
  image(backgroundImage,0,0,402,874);
  
  translate(0, -scrollY);  // 스크롤

  image(statusBar,0,0,402,90);
  // 각 위젯 그리기
  calendarWidget.display();
  vitalCheckWidget.display();
  checklistWidget.display();
  walletWidget.display();
  batteryWidget.display(); // Battery 위젯 출력
}

// 마우스 드래그로 스크롤 이동
void mouseDragged() {
  int scrollSpeed = 2;  // 스크롤 속도
  scrollY -= (mouseY - pmouseY) * scrollSpeed;  // 이동량 계산 (반전)
  scrollY = constrain(scrollY, 0, contentHeight - screenHeight);  // 범위 제한
}

// 마우스 클릭 이벤트 처리
void mousePressed() {
  calendarWidget.toggleButtons(mouseX, mouseY, scrollY);
  calendarWidget.handleArrows(mouseX, mouseY, scrollY);
  checklistWidget.handleMousePress(mouseX, mouseY, scrollY);
  batteryWidget.handleClick(mouseX, mouseY + scrollY); // 스크롤 보정하여 클릭 처리
}