class StockWidget {
  float y;
  StockWidget(float y) {
    this.y = y;
  } 
  void display() {
    fill(150);
    rect(20, 850, 360, 100, 10);
    fill(255);
    textSize(14);
    textAlign(LEFT);
    text("AAPL: 229.00", 40, 880);
    text("MSFT: 417.14", 40, 900);
    text("TSLA: 213.97", 40, 920);
  }
}