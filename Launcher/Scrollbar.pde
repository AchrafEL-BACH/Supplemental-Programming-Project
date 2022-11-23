//Scroolbar class, it's just a scrollbar
class Scrollbar {
  float pY, pX, minX, offset;
  float barWidth, canvasWidth, scrollWindow, scrollbarSize;
  boolean hold = false;

  Scrollbar(float x, float y, float canvasWidth, float scrollWindow, float scrollbarSize) {
    pY = y;
    pX = 0;
    minX = x;
    this.canvasWidth = canvasWidth;
    this.scrollWindow = scrollWindow;
    this.scrollbarSize = scrollbarSize;
    barWidth = scrollWindow == canvasWidth ? scrollbarSize : scrollWindow / canvasWidth * scrollWindow;
  }

  public void move() {
    if (hold) {
      pX = mouseX - offset - minX;
      if (pX < 0) pX = 0; //<>//
      else if (pX + barWidth > scrollbarSize) pX = scrollbarSize-barWidth;
    }
  }

  public void draw() {
    strokeWeight(1);
    stroke(0);
    fill(210);
    rect(minX, pY, scrollbarSize, 20);
    fill(hold ? 100 : 160);
    rect(minX + pX, pY, barWidth, 20);
    noStroke();
  }

  public void pressed() {
    if (mouseY >= pY && mouseY <= pY+20 && mouseX >= minX+pX && mouseX <= minX+pX+barWidth) {
      hold = true;
      offset = mouseX-minX-pX;
    }
  }

  public void released() {
    hold = false;
  }

  public void scrolled(float scroll, float position) {
    float v = map(50, 0, canvasWidth - scrollWindow, 0, scrollbarSize-barWidth);
    v = Double.isNaN(v) ? 1 : v;
    if (position < 0) {
      pX += v * PApplet.parseInt(scroll / abs(scroll));
      pX = round(pX/v) * v;
    } else {
      pX = v * position;
    }
    if (pX<0) pX = 0;
    else if (pX+barWidth>scrollbarSize) pX=scrollbarSize-barWidth;
  }

  public int scrollValue() {
    return (int)map(pX, -0.1f, scrollbarSize-barWidth, -0.1f, canvasWidth - scrollWindow);
  }
}
