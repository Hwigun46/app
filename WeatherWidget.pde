class WeatherWidget {   
    float y;
    WeatherWidget(float y) {
        this.y = y;
    }   
    void display() {
        fill(100);
        rect(30, 370, 320, 100, 10);
        
        fill(255);
        textAlign(LEFT);
        textSize(14);
        text("서울 22°", 40, 400);
        textSize(10);
        text("맑음", 40, 420);
    }
}