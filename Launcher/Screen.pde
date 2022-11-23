//Abstract class Screen acting as a recipient for the different user interactive displays to allow a fluid change of view and an easier interaction with the window
abstract class Screen {
  //int width, height;
  float x, y;
  
  Screen(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  void draw(){
    fill(170, 170, 255);
    rect(width - 100, height - 80, 99, 79);
    fill(0);
    textAlign(CENTER,CENTER);
    textSize(40);
    text("Back", width - 50, height - 40);
  }
  String mousePressed(){
    if(mouseX >= width - 100 && mouseX <= width && mouseY >= height - 80 && mouseY <= height) return "BACK";
    return null;
  }
  abstract void mouseWheel(float e);
  abstract void mouseReleased();
}
