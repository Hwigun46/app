class CallWidget {
    float y;
    CallWidget(float y) {
        this.y = y;
    }
    void display() {
        fill(100);
        rect(30, 300, 150, 50, 10);  // 의사 콜
        rect(200, 300, 150, 50, 10); // 요청 콜
        
        fill(255);
        textAlign(CENTER, CENTER);
        textSize(12);
        text("의사 콜", 105, 325);
        text("이송 요청 콜", 275, 325);
    }
}