import java.net.URL;
import java.net.HttpURLConnection;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import org.json.JSONObject;
import org.json.JSONArray;
import java.util.Calendar;
import java.text.SimpleDateFormat;
import java.util.Date;

// 기본 설정
int scrollY = 0;
int screenHeight = 874;
int contentHeight = 1461;

// 이미지 및 폰트
PImage backgroundImage;
PImage statusBar;
PFont font;

// 위젯 객체
CalendarWidget calendarWidget;
VitalCheckWidget vitalCheckWidget;
CallWidget callWidget;
ChecklistWidget checklistWidget;
WalletWidget walletWidget;
BatteryWidget batteryWidget;
WeatherWidget weatherWidget;
StockWidget stockWidget;

// API 인증키
String apiKey = "%2BrYEn1ETgl%2BXi79LFibROdqGXYbWZUH1p4ryFUEuRA%2Bb4fQkvQuv8aMBcDda2UgFQOfPaaFe%2F2tOPgUBUUDDvw%3D%3D";

void settings() {
  size(402, screenHeight);
  backgroundImage = loadImage("data/image/blurScreen.png");
  statusBar = loadImage("data/image/statusbar.png");
}

void setup() {
  font = createFont("font/d2coding.ttf", 14);
  textFont(font);

  // 위젯 초기화
  calendarWidget = new CalendarWidget(32, 70);
  vitalCheckWidget = new VitalCheckWidget(32, 593, font);
  weatherWidget = new WeatherWidget(212, 770, font); // WeatherWidget 초기화`
  checklistWidget = new ChecklistWidget(32, 881);
  walletWidget = new WalletWidget(32, 1233);
  batteryWidget = new BatteryWidget(32, 1058);
  stockWidget = new StockWidget(214,1058);
  callWidget = new CallWidget(212, 593);
  // 날씨 데이터 가져오기
  fetchWeatherData();
}

void draw() {
  image(backgroundImage, 0, 0, 402, 874); // 배경화면
  image(statusBar, 0, 0, 402, 90);        // 상태바

  // 스크롤된 상태로 위젯 그리기
  
  translate(0, -scrollY);
  drawWidgets(); // 스크롤된 상태로 위젯 표시
  

  // 팝업 활성화 시 팝업을 스크롤 상태에 맞게 표시
  if (callWidget.isPopupVisible) {
    callWidget.showPopup(); // 스크롤 위치 기준 정중앙에 표시
  }
}



void drawWidgets() {
  // 각 위젯을 그리는 함수
  calendarWidget.display();
  vitalCheckWidget.display();
  checklistWidget.display();
  weatherWidget.display();
  walletWidget.display();
  batteryWidget.display();
  stockWidget.display();
  callWidget.display();
}

// 날씨 데이터 가져오기
void fetchWeatherData() {
    String nx = "58";  // 격자 X (안산)
    String ny = "121"; // 격자 Y (안산)
    String baseDate = getCurrentDate(); // 당일 날짜
    String baseTime = calculateNearestBaseTime(); // 조건에 맞는 발표 시각

    String apiUrl = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
                    + "?serviceKey=" + apiKey
                    + "&numOfRows=100"
                    + "&pageNo=1"
                    + "&dataType=JSON"
                    + "&base_date=" + baseDate
                    + "&base_time=" + baseTime
                    + "&nx=" + nx
                    + "&ny=" + ny;

    try {
        println("API URL: " + apiUrl);
        String responseText = fetchData(apiUrl);
        println("API Response: " + responseText);

        if (responseText.contains("\"NO_DATA\"")) {
            println("No data available for the requested parameters.");
        } else {
            parseWeatherData(responseText);
        }
    } catch (Exception e) {
        println("Error fetching weather data: " + e.getMessage());
    }
    println("Base Date: " + baseDate);
    println("Base Time: " + baseTime);
}

// 당일 날짜 반환
String getCurrentDate() {
    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
    return sdf.format(new Date());
}

// 조건에 맞는 발표 시각 계산
String calculateNearestBaseTime() {
    int[] baseTimes = {200, 500, 800, 1100, 1400, 1700, 2000, 2300};
    Calendar now = Calendar.getInstance();

    // 현재 시각
    int currentHour = now.get(Calendar.HOUR_OF_DAY);
    int currentMinute = now.get(Calendar.MINUTE);
    int currentTime = currentHour * 100 + currentMinute;

    // 가장 가까운 발표 시각 찾기
    for (int i = baseTimes.length - 1; i >= 0; i--) {
        int baseTime = baseTimes[i];
        if (currentTime >= baseTime + 10) { // 발표 시각 + 10분 이후부터 호출 가능
            return String.format("%04d", baseTime); // 4자리 문자열로 반환
        }
    }

    // 모든 조건을 만족하지 못하면 하루 전날 마지막 발표 시각 반환
    return "2300";
}

void parseWeatherData(String data) {
    try {
        JSONObject json = new JSONObject(data);
        JSONArray items = json.getJSONObject("response")
                              .getJSONObject("body")
                              .getJSONObject("items")
                              .getJSONArray("item");

        // 초기값 설정
        String weather = "N/A";
        String weatherview = "N/A";
        String currentTemp = "N/A";
        double maxTemp = Double.MIN_VALUE; // 최고 기온 초기값
        double minTemp = Double.MAX_VALUE; // 최저 기온 초기값

        int currentHour = Calendar.getInstance().get(Calendar.HOUR_OF_DAY); // 현재 시간
        String nearestTemp = null; // 현재 시간과 가장 가까운 기온 데이터

        // 데이터 순회
        for (int i = 0; i < items.length(); i++) {
            JSONObject item = items.getJSONObject(i);
            String category = item.getString("category");
            String fcstValue = item.getString("fcstValue");
            String fcstTime = item.getString("fcstTime");

            // TMP 또는 TMX 데이터만 처리
            if (category.equals("TMP") || category.equals("TMX")) {
                try {
                    double temp = Double.parseDouble(fcstValue);

                    // 현실적인 기온 범위(-50°C ~ 50°C) 내 데이터만 처리
                    if (temp >= -50 && temp <= 50) {
                        // 최고/최저 기온 계산
                        maxTemp = Math.max(maxTemp, temp);
                        minTemp = Math.min(minTemp, temp);

                        // 현재 시간과 가장 가까운 시간의 기온
                        int fcstHour = Integer.parseInt(fcstTime.substring(0, 2)); // "1200" -> 12
                        if (nearestTemp == null || Math.abs(currentHour - fcstHour) < Math.abs(currentHour - Integer.parseInt(nearestTemp))) {
                            nearestTemp = fcstValue;
                        }
                    }
                } catch (NumberFormatException e) {
                    println("Invalid temperature value: " + fcstValue);
                }
            }

            // SKY 데이터 처리
            if (category.equals("SKY")) {
                if (fcstValue.equals("1")) weatherview = "맑음";
                else if (fcstValue.equals("3")) weatherview = "구름많음";
                else if (fcstValue.equals("4")) weatherview = "흐림";
            }

            // PTY 데이터 처리
            if (category.equals("PTY")) {
                if (fcstValue.equals("0")) weather = "강수없음";
                else if (fcstValue.equals("1")) weather = "비";
                else if (fcstValue.equals("2")) weather = "비/눈";
                else if (fcstValue.equals("3")) weather = "눈";
            }
        }

        // 최고 기온과 최저 기온 형식화
        String maxTempStr = maxTemp == Double.MIN_VALUE ? "N/A" : maxTemp + "°";
        String minTempStr = minTemp == Double.MAX_VALUE ? "N/A" : minTemp + "°";
        String nearestTempStr = nearestTemp != null ? Math.round(Double.parseDouble(nearestTemp)) + "°" : "N/A";

        // WeatherWidget 업데이트
        weatherWidget.updateWeather(
            weather,          // 날씨 상태
            weatherview,      // 하늘 상태
            nearestTempStr,   // 현재 기온
            maxTempStr,       // 최고 기온
            minTempStr        // 최저 기온
        );

        // 디버깅 출력
        println("Weather: " + weather);
        println("Weatherview: " + weatherview);
        println("Current Temp: " + nearestTempStr);
        println("Max Temp: " + maxTempStr);
        println("Min Temp: " + minTempStr);
    } catch (Exception e) {
        println("Error parsing weather data: " + e.getMessage());
    }
}

String fetchData(String apiUrl) {
  try {
    URL url = new URL(apiUrl);
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("GET");
    BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
    StringBuilder sb = new StringBuilder();
    String line;

    while ((line = br.readLine()) != null) {
      sb.append(line);
    }
    br.close();
    return sb.toString();
  } catch (Exception e) {
    println("HTTP Request Failed: " + e.getMessage());
    return null;
  }
}
// 마우스 드래그로 스크롤 이동
void mouseDragged() {
  if (callWidget.isPopupVisible) return; // 팝업이 활성화 중이면 스크롤 무시

  int scrollSpeed = 2;
  scrollY -= (mouseY - pmouseY) * scrollSpeed;
  scrollY = constrain(scrollY, 0, contentHeight - screenHeight);
}

// 마우스 클릭 이벤트 처리
void mousePressed() {
  // 팝업이 활성화된 경우
  if (callWidget.isPopupVisible) {
    callWidget.handlePopupClick(mouseX, mouseY); // 팝업 클릭만 처리
    return; // 팝업 클릭 처리 후 다른 클릭 이벤트 무시
  }

  // 팝업이 비활성화된 경우 다른 위젯 클릭 처리
  calendarWidget.toggleButtons(mouseX, mouseY, scrollY);
  calendarWidget.handleArrows(mouseX, mouseY, scrollY);
  callWidget.handleClick(mouseX, mouseY + scrollY);
  checklistWidget.handleMousePress(mouseX, mouseY, scrollY);
  batteryWidget.handleClick(mouseX, mouseY + scrollY);
}

