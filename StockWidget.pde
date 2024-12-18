class StockWidget {
  PImage stockImage; // Wallet 이미지
  float x, y;         // 위젯 위치

  StockWidget(float x, float y) { // 수정된 부분
    this.x = x;
    this.y = y;
    stockImage = loadImage("data/image/stock.png"); // 이미지 로드
  }

  void display() {
    image(stockImage, x, y, 158, 158);
  }
}