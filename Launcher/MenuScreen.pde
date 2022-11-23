//Screen implementation of the main menu, the first page where the user can select an option to change screens
class MenuScreen extends Screen {
  
  MenuScreen(float x, float y){
    super(x,y);
  }
  
  void draw(){
    fill(170, 170, 255);
    rect(100, 100, 300, 100);
    rect(100, 250, 300, 100);
    rect(100, 400, 300, 100);
    
    fill(0);
    textSize(30);
    textAlign(LEFT, CENTER);
    text("Store Selection", 105, 150);
    text("Customer Selection", 105, 300);
    text("Product Selection", 105, 450);
    
    fill(0, 100);
    textSize(70);
    textAlign(CENTER, CENTER);
    text("TRINITY STORE", width/2, 600);
    textSize(74);
    fill(0, 0, 200);
    text("TRINITY STORE", width/2, 606);
    image(loadImage("Trinity_College_Dublin.png"), 450, 50, 500, 500);
  }
  
  String mousePressed(){
    if(mouseX >= 100 && mouseX <= 400){
      boolean isInBlankSpace = (((mouseY-100) / 50 + 1) % 3) == 0 || mouseY < 100 || mouseY > 500;
      if(!isInBlankSpace){
        int buttonNb = (mouseY - 100) / 150;
        println(buttonNb);
        switch(buttonNb){
          case 0:    //Redirect to the selection screen for stores
            return "SELECTION->STORES";
          case 1:    //Redirect to the selection screen for customers
            return "SELECTION->CUSTOMERS";
          case 2:    //Redirect to the selection screen for products
            return "SELECTION->PRODUCTS";
          default:
            break;
        }
      }
    }
    return null;
  }
  
  void mouseWheel(float e){
    
  }
  
  void mouseReleased(){
    
  }
}
