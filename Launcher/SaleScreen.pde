//Screen implementation of the TIME request / the list of sales for each date
class SaleScreen extends Screen{
  String subject;        //Title displayed in TOP-LEFT corner
  PImage dateHistory;    //The image with all the data draw
  Scrollbar sb;          //The scroll bar under the data box
  
  SaleScreen(float x, float y, SaleInfo[] sales, String subject){
    super(x,y);
    this.subject = subject;
    LocalDate currentDate = null;
    dateHistory = createGraphics(700,0);
    PGraphics newSale;
    int w, h;
    for(SaleInfo sale: sales){
      if(currentDate == null || !currentDate.equals(sale.get_date())){  //When a new date is found, we first add the date header
        w = dateHistory.width; h = dateHistory.height;
        currentDate = sale.get_date();
        
        newSale = createGraphics(w, h + 100);        //We create a new bigger image containing the old one because it not possible to resize an image without rescaling it (meaning that we leave a blank space for the next data)
        newSale.beginDraw();
        newSale.image(dateHistory, 0, 0);
        newSale.fill(0);
        newSale.rect(0, h+50, w, 50);
        newSale.fill(255);
        newSale.textAlign(CENTER, CENTER);
        newSale.textSize(40);
        newSale.text(currentDate.toString(), w/2, h+70);
        newSale.endDraw();
        dateHistory = newSale.get();
      }
      w = dateHistory.width; h = dateHistory.height;                      //We add a list cell for each sale of the same date
      newSale = createGraphics(w, h + 50);            //We create a new bigger image containing the old one because it not possible to resize an image without rescaling it (meaning that we leave a blank space for the next data)
      newSale.beginDraw();
      newSale.image(dateHistory, 0, 0);
      newSale.stroke(0);
      newSale.noFill();
      newSale.rect(0, h, w-1, 49);
      newSale.fill(0);
      newSale.textSize(30);
      newSale.textAlign(LEFT, CENTER);
      newSale.text(sale.get_product(), 5, h + 25);
      newSale.textAlign(RIGHT, CENTER);
      newSale.text(String.format("%.2f", sale.get_price() - sale.get_discount())+" €", w - 5, h + 25);
      newSale.endDraw();
      dateHistory = newSale.get();
    }
    dateHistory = dateHistory.get(0, 50, dateHistory.width, dateHistory.height - 50);    //We get rid of a useless blank space at the beginning
    sb = new Scrollbar(100, 650, max(500, dateHistory.height), 500, 700);
  }
  
  void draw(){
    image(dateHistory.get(0,sb.scrollValue(),700,500), 100, 150);
    sb.move();
    sb.draw();
    
    stroke(0, 120);
    noFill();
    rect(100, 150, 700, 500);
    fill(0);
    textAlign(LEFT, TOP);
    textSize(40);
    text(subject, 50, 10);
    
    super.draw();
  }
  String mousePressed(){
    sb.pressed();
    return super.mousePressed();
  }
  void mouseWheel(float e){
    if(mouseX >= 100 && mouseX <= 800 && mouseY >= 150 && mouseY <= 670) sb.scrolled(e, -1);
  }
  void mouseReleased(){
    sb.released();
  }
  
}
