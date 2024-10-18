int scrollY = 0;  // 스크롤 위치
int screenHeight = 874;  // 아이폰 화면 크기
int contentHeight = 1228; // 전체 컨텐츠 길이

CalendarWidget calendarWidget;
CallWidget callWidget;
WeatherWidget weatherWidget;
CheckListWidget checkListWidget;
BatteryWidget batteryWidget;
StockWidget stockWidget;

PFont font;

void settings(){
  size(402, screenHeight);
}

void setup() {
  // TrueType 폰트(.ttf) 파일을 로드
  font = createFont("d2coding.ttf", 32);  // 32는 폰트 크기
  textFont(font);  // 기본 폰트로 설정

  // 위젯 인스턴스 생성, Y 좌표를 명확히 설정
  calendarWidget = new CalendarWidget(0);        // Y 좌표 0부터 시작
  callWidget = new CallWidget(400);              // Y 좌표 400부터 시작
  weatherWidget = new WeatherWidget(500);        // Y 좌표 500
  checkListWidget = new CheckListWidget(650);    // Y 좌표 650
  batteryWidget = new BatteryWidget(850);         // Y 좌표 850
  stockWidget = new StockWidget(1050);            // Y 좌표 1050
}

void draw() {
  background(240);
  translate(0, -scrollY);  // 스크롤 기능

  // 각 위젯을 출력
  calendarWidget.display();
  callWidget.display();
  weatherWidget.display();
  checkListWidget.display();
  batteryWidget.display();
  stockWidget.display();
}

// 마우스 드래그로 스크롤 이동
void mouseDragged() {
  // 스크롤 속도 조절
  int scrollSpeed = 2;  // 이동 속도 설정
  scrollY += (mouseY - pmouseY) * scrollSpeed; // 이동량에 스크롤 속도를 곱함
  scrollY = constrain(scrollY, 0, contentHeight - screenHeight); // 스크롤 범위 제한
}