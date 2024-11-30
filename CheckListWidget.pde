class CheckListWidget{
  float y;
  CheckListWidget(float y){
    this.y = y;
  }
     void display() {
    fill(200);
    rect(20, 560, 360, 150, 10);  // 체크리스트 배경
    fill(0);
    textSize(14);
    textAlign(LEFT, CENTER);
    text("근무 체크리스트", 40, 590);

    // 체크리스트 항목
    String[] tasks = {"근무 1", "근무 2", "근무 3", "근무 4"};
    for (int i = 0; i < tasks.length; i++) {
      text(tasks[i], 40, 620 + i * 30);
    }
  }
}