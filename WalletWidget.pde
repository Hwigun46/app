class WalletWidget {
  PImage walletImage; // Wallet 이미지
  float x, y;         // 위젯 위치

  WalletWidget(float x, float y) {
    this.x = x;
    this.y = y;
    walletImage = loadImage("data/image/wallet.png"); // 이미지 로드
  }

  void display() {
    image(walletImage, x, y, 158, 158); // Wallet 이미지 출력
  }
}