// The avatar class is a desing class only, it allows to create a unique rendering of the customers and stores

class Avatar {
  int type;
  String name;
  PImage image;
  
  Avatar(int t, String n){
    this.type = t;
    this.name = n;
    
    switch(type){
      case 0:
        drawPerson();
        break;
      case 1:
        drawBuilding();
        break;
      case 2:
        drawProduct();
        break;
    }
  }
  
  void drawPerson(){
    float f = sqrt(random(0.1, 1));
    PGraphics customer = createGraphics(501, 500);
    customer.beginDraw();
    customer.fill(random(120), random(120), random(120));
    customer.triangle(0, 500, 500, 500, 250, 150);
    customer.line(250, 150, 250, 500);
    customer.fill(random(255), random(255), random(255));
    customer.ellipse(250, 100, 300, 200);
    customer.fill(f*250, f*220, f*180);
    customer.circle(250, 150, 200);
    customer.fill(255);
    customer.ellipse(220, 120, 30, 80);
    customer.ellipse(280, 120, 30, 80);
    customer.endDraw();
    image = customer.get();
  }
  
  void drawBuilding(){
    PGraphics building = createGraphics(501, 500);
    building.beginDraw();
    building.fill(random(255), random(255), random(255));
    building.rect(0, 300, 500, 200);
    building.noFill();
    building.rect(220, 400, 60, 100);
    int triangle_amount = round(random(1, 4.5)) * 2;
    int triangle_width = 500 / triangle_amount;
    boolean leftSided = random(2) > 1;
    building.fill(random(255), random(255), random(255));
    for(int i = 0, j = 0; i < triangle_amount; i++, j = j + triangle_width){
      building.triangle(j, 300, j+triangle_width, 300, leftSided ? j : j+triangle_width, random(50, 200));
    }
    building.endDraw();
    image = building.get();
  }
  
  void drawProduct(){
    PGraphics product = createGraphics(501, 500);
    product.beginDraw();
    product.textAlign(CENTER, CENTER);
    product.fill(0);
    product.textSize(450);
    product.text(name.substring(0, 1), 246, 246);
    product.text(name.substring(0, 1), 254, 254);
    product.fill(random(255), random(255), random(255));
    product.text(name.substring(0, 1), 250, 250);
    product.endDraw();
    image = product.get();
  }
  
  PImage getImage(){
    return image;
  }
  
  String get_name(){
    return name;
  }
  
  int get_type(){
    return type;
  }
}
