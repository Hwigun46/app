class WeatherWidget {
  float x, y; // 위젯 위치
  String weather = "비";
  String weatherview = "맑음";
  String temp = "0°";
  String highTemp = "N/A";
  String lowTemp = "N/A";
  String city = "안산"; // 도시 이름

  PImage backgroundImg, weatherIcon, locateIcon;
  PFont font;

  WeatherWidget(float x, float y, PFont font) {
    this.x = x;
    this.y = y;
    this.font = font;

    // 기본 이미지 로딩
    backgroundImg = loadImage("data/image/clear_back.png");  // 기본 배경 이미지
    weatherIcon = loadImage("data/image/sun.png"); // 기본 날씨 아이콘
    locateIcon = loadImage("data/image/location.png");
  }

  void updateWeather(String weather, String weatherview, String temp, String highTemp, String lowTemp) {
    this.weather = weather;
    this.weatherview = weatherview;
    this.temp = temp;
    this.highTemp = highTemp;
    this.lowTemp = lowTemp;

    // 디버깅: 전달받은 값들 확인
    println("Weather: " + weather);
    println("Weatherview: " + weatherview);

    // 날씨에 맞는 배경 이미지와 아이콘 설정
    if (weatherview.equals("맑음") && weather.equals("강수없음")) {
        backgroundImg = loadImage("data/image/clear_back.png");
        weatherIcon = loadImage("data/image/sun.png");
        println("맑음 - 강수없음");
    } else if (weatherview.equals("구름많음") && weather.equals("강수없음")) {
        backgroundImg = loadImage("data/image/clear_back.png");
        weatherIcon = loadImage("data/image/cloud.png");
        println("구름 많음 - 강수없음");
    } else if (weatherview.equals("흐림") && weather.equals("강수없음")) {
        backgroundImg = loadImage("data/image/cloudy_back.png");
        weatherIcon = loadImage("data/image/cloud.png");
        println("흐림 - 강수없음");
    } else if (weather.equals("흐림") && weather.equals("비")) {
        backgroundImg = loadImage("data/image/cloudy_back.png");
        weatherIcon = loadImage("data/image/rain.png");
        println("흐림 - 비");
    } else if (weather.equals("눈")) {
        backgroundImg = loadImage("data/image/cloudy_back.png");
        weatherIcon = loadImage("data/image/snow.png");
        println("눈");
    } else if (weather.equals("비")) {
        backgroundImg = loadImage("data/image/cloudy_back.png");
        weatherIcon = loadImage("data/image/rain.png");
        println("비");
    }
    
    // 이미지가 null인 경우 처리
    if (backgroundImg == null) {
        println("Error loading background image");
    }
    if (weatherIcon == null) {
        println("Error loading weather icon");
    }
}

  void display() {
    // 배경 이미지 그리기
    if (backgroundImg != null) {
      image(backgroundImg, x, y, 158, 92); // 배경 크기 158x92
    } else {
      println("Background image is not loaded properly");
    }
    
    // 날씨 아이콘 그리기
    if (weatherIcon != null) {
      image(weatherIcon, x + 126, y + 16.5, 20, 20); // 아이콘 크기 20x20
    } else {
      println("Weather icon is not loaded properly");
    }

    image(locateIcon, x+ 50.5, y + 20, 12, 12);

    textFont(font);
    
    // 텍스트 출력
    fill(255); // 흰색 텍스트
    

    // 도시 이름 출력
    textSize(20);
    text(city, x + 27, y + 22);

    // 현재 기온 출력
    textSize(40);
    text(temp, x + 34, y + 60);

    // 날씨 상태 출력 (Sunny)
    textSize(14);
    text(weatherview, x + 125, y + 55);

    // 최고/최저 기온 출력
    textSize(13);
    text("H:" + highTemp + " L:" + lowTemp, x + 110, y + 76);
  }  
}