//Screen implementation of the SELECTION request / the horizontal select screen with an image display
class SelectionScreen extends Screen {
  ArrayList<Avatar> icons;
  int index, type;
  String topic;

  //Constructor
  SelectionScreen(float x, float y, ArrayList<Avatar> items) {
    super(x, y);
    this.icons = items;
    this.type = items.get(0).get_type(); //<>//
    this.topic = new String[]{"Customers", "Stores", "Products"}[type];
    this.index = 0;
  }
  
  //Constructor with a title prefix
  SelectionScreen(float x, float y, ArrayList<Avatar> items, String topicPrefix) {
    this(x, y, items);
    this.topic = topicPrefix + "->" + this.topic;
  }

  //Method to check if a point is in a triangle using barimetrics
  boolean isInTriangle(float pt_x, float pt_y, float x1, float y1, float x2, float y2, float x3, float y3) {
    float denom = (y2 - y3) * (x1 - x3) + (x3 - x2) * (y1 - y3);
    float a = ((y2 - y3) * (pt_x - x3) + (x3 - x2) * (pt_y - y3)) / denom;
    float b = ((y3 - y1) * (pt_x - x3) + (x1 - x3) * (pt_y - y3)) / denom;
    float c = 1 - a - b;
    return min(a, b, c) >= 0 && max(a, b, c) <= 1;
  }

  void draw() {
    Avatar current = icons.get(index);
    image(current.getImage().get(0, 0, 501, 500), 200, 200, 300, 300);

    fill(255, 0, 0);
    triangle(100, 350, 150, 300, 150, 400);
    triangle(600, 350, 550, 300, 550, 400);
    fill(170, 170, 255);
    rect(650, 200, 300, 100);
    rect(650, 350, 300, 100);

    fill(0);
    textAlign(LEFT, TOP);
    textSize(70);
    text(topic, 50, 10);
    textSize(50);
    textAlign(CENTER, TOP);
    text(current.get_name(), 350, 505);
    textSize(25);
    textAlign(CENTER, CENTER);
    switch(type) {
      case 0: //CUSTOMERS
        text("PURCHASE LIST", 800, 250);
        text("MOST POPULAR BUYS", 800, 400);
        break;
      case 1: //STORES
        text("CUSTOMER LIST", 800, 250);
        text("BIGGEST BUYERS", 800, 400);
        break;
      case 2: //PRODUCTS
        text("POPULARITY OVER TIME", 800, 250);
        text("POPULARITY BY STORE", 800, 400);
        break;
    }

    super.draw();
  }

  String mousePressed() {
    if (isInTriangle(mouseX, mouseY, 100, 350, 150, 300, 150, 400)) mouseWheel(1);
    else if (isInTriangle(mouseX, mouseY, 600, 350, 550, 300, 550, 400)) mouseWheel(-1);
    else if (mouseX >= 650 && mouseX <= 950) {
      String[] actionChain = topic.split("->");
      if (mouseY >= 200 && mouseY <= 300) {
        switch(type) {
        case 0:        //CUSTOMERS SCREEN FIRST BUTTON
          return "LIST->SALES->CUSTOMER:" + icons.get(index).get_name() + (actionChain.length > 1 ? "->STORE:"+actionChain[0] : "");
        case 1:        //STORES SCREEN FIRST BUTTON
          return "SELECTION->CUSTOMERS->" + icons.get(index).get_name();
        case 2:        //PRODUCTS SCREEN FIRST BUTTON
          return "TIME->DATE->PRODUCT->" + icons.get(index).get_name();
        }
      } else if (mouseY >= 350 && mouseY <= 450) {
        switch(type) {
        case 0:        //CUSTOMERS SCREEN SECOND BUTTON
          return "GRAPH->PRODUCT->CUSTOMER:" + icons.get(index).get_name() + (actionChain.length > 1 ? "->STORE:"+actionChain[0] : "");
        case 1:        //STORES SCREEN SECOND BUTTON
          return "GRAPH->CUSTOMER->STORE:" + icons.get(index).get_name();
        case 2:        //PRODUCTS SCREEN SECOND BUTTON
          return "TIME->STORE->PRODUCT->" + icons.get(index).get_name();
        }
      }
    }
    return super.mousePressed();
  }

  void mouseWheel(float scroll) {
    index = Math.floorMod(index + parseInt(scroll / abs(scroll)), icons.size());
  }

  void mouseReleased() {
  }
}
