import java.util.Map; //<>//
import java.util.TreeMap;

class GraphList<S extends Comparable<? super S>, T> {
  boolean listMode, sortByOccurence;
  Map.Entry<S, Integer>[] occurences;
  T subject;
  Map.Entry<S, Integer> selected;

  static final int CUSTOMER = 0;
  static final int STORE = 1;
  static final int DATE = 2;
  static final int PRODUCT = 3;
  String[] sale_methods = new String[]{"get_customer->get_name", "get_store->get_name", "get_date", "get_product"};

  int step_amount, step_length;
  float x, y;
  PImage graph, layout;
  Scrollbar sb;

  //Filtered list constructor.
  GraphList(float x, float y, SaleInfo[] sales, int occurenceKey, int occurenceValue, T value) {
    this.x = x;
    this.y = y;
    this.listMode = false; //Start on false while having a listat the beginning cause I use the switch view for automation purposes
    this.sortByOccurence = false;
    this.subject = value;
    try {
      ArrayList<Method> getValue = new ArrayList();
      Object lastItem = sales[0];
      /*
        Using Java reflection API we can retrieve the class SaleInfo's methods only using the ID we definied with the static final attributes.
       With the reflection API we get the sought method by its name. We can then reuse the corresponding methods however we want.
       This proceeding allows us to have a stable class with generic types.
       */
      for (String method: sale_methods[occurenceValue].split("->")) {
        Method m = lastItem.getClass().getMethod(method);
        getValue.add(m);
        lastItem = m.invoke(lastItem);
      }
      Map<S, Integer> occurenceCount = new TreeMap();
      for (SaleInfo sale : sales) {
        lastItem = sale;
        for (Method method : getValue)
          lastItem = method.invoke(lastItem);
        T saleValue = (T) lastItem;
        Object item = sale;
        for (String method : sale_methods[occurenceKey].split("->"))
          item = item.getClass().getMethod(method).invoke(item);
        S keyValue = (S) item;
        if (saleValue.equals(value)) occurenceCount.merge(keyValue, 1, (a, b) -> a + b);
      }
      occurences = occurenceCount.entrySet().toArray(Map.Entry[]::new);
    }
    catch (Exception e) {
    }
    float max_value = Arrays.stream(occurences).max(
      (o1, o2) -> o1.getValue().compareTo(o2.getValue())).orElse(null).getValue();

    step_length = 1;
    while (max_value/step_length > 10) {
      if (step_length == 1) step_length = 5;
      else if (isTenExponent(step_length)) step_length = (int)(step_length * 2.5f);
      else step_length = step_length * 2;
    }
    step_amount = ceil(max_value/step_length);
    switchView();
  }

  //Non-Filtered list constructor.
  GraphList(float x, float y, SaleInfo[] sales, int occurenceKey, T subject) {
    this.x = x;
    this.y = y;
    this.listMode = false; //Start on false while having a listat the beginning cause I use the switch view for automation purposes
    this.sortByOccurence = false;
    this.subject = subject;
    try {
      /*
        Using Java reflection API we can retrieve the class SaleInfo's methods only using the ID we definied with the static final attributes.
       With the reflection API we get the sought method by its name. We can then reuse the corresponding methods however we want.
       This proceeding allows us to have a stable class with generic types.
       */
      Map<S, Integer> occurenceCount = new TreeMap();
      for (SaleInfo sale : sales) {
        Object item = sale;
        for (String method : sale_methods[occurenceKey].split("->"))
          item = item.getClass().getMethod(method).invoke(item);
        S keyValue = (S) item;
        occurenceCount.merge(keyValue, 1, (a, b) -> a + b);
      }
      occurences = occurenceCount.entrySet().toArray(Map.Entry[]::new);
    }
    catch (Exception e) {
    }
    float max_value = Arrays.stream(occurences).max(
      (o1, o2) -> o1.getValue().compareTo(o2.getValue())).orElse(null).getValue();

    step_length = 1;
    while (max_value/step_length > 10) {
      if (step_length == 1) step_length = 5;
      else if (isTenExponent(step_length)) step_length = (int)(step_length * 2.5f);
      else step_length = step_length * 2;
    }
    step_amount = ceil(max_value/step_length);
    switchView();
  }

  //Method to check if a number is a power of ten
  public boolean isTenExponent(int n) {
    if (n<10) return n == 1;
    return isTenExponent(n/10);
  }

  public Map.Entry<S, Integer>[] getGraph() {
    return occurences;
  }

  //Return an image containing all the dataPoints on a graph
  public PImage getGraphImage(int w, int h, int[] occurences) {
    PGraphics data = createGraphics(w, 500);
    data.beginDraw();
    data.background(255);
    data.strokeWeight(2);
    float preValue = map(occurences[0], 0, h, 500, 0);
    data.circle(0, preValue, 8);
    for (int k = 0, i = 0; i < occurences.length-1; i++, k = k + 50) {
      float occurence = map(occurences[i+1], 0, h, 500, 0);
      data.line(k, preValue, k + 50, occurence);
      data.circle(k + 50, occurence, 8);
      data.line(k + 50, occurence, k + 50, 500);
      preValue = occurence;
    }
    data.endDraw();
    return data.get();
  }

  //Return the layer containing the scale lines of the graph
  public PImage getGraphOverlay(int step_length, int step_amount) {
    PGraphics layer = createGraphics(500, 500);
    layer.beginDraw();
    layer.strokeWeight(3);
    layer.fill(120, 150);
    layer.stroke(120, 100);
    int h = step_length * step_amount;
    for (int i = 1; i <= step_amount; i++) {
      float yPos = map(step_length * i, 0, h, 500, 0);
      layer.line(0, yPos+1, 500, yPos+1);
      layer.text(step_length * i, 470, yPos + 20);
    }
    layer.endDraw();
    return layer.get();
  }

  //Return a list with all the dataPoint in "attribute to occurences" format
  public PImage getListImage(int h, Map.Entry[] entrySet) {
    PGraphics data = createGraphics(500, h);
    data.beginDraw();
    data.background(255);
    data.strokeWeight(2);
    for (int i = 0; i < entrySet.length; i++) {
      float y = i*50;
      data.fill(255);
      data.rect(0, y, 500, 50);
      Map.Entry entry = entrySet[i];
      println(entry.toString());
      data.fill(0);
      data.textSize(28);
      data.text(entry.getKey().toString(), 10, y + 40);
      data.text(entry.getValue().toString(), 400, y + 40);
    }
    return data.get();
  }

  //Return the layer with the titles and the list frame
  public PImage getListOverlay() {
    PGraphics layer = createGraphics(500, 500);
    layer.beginDraw();
    layer.rect(0, 0, 499, 50);
    layer.fill(0);
    layer.textSize(28);
    layer.text("Attribute", 50, 45);
    layer.text("Occurences", 355, 45);
    layer.line(350, 0, 350, 500);
    layer.noFill();
    layer.rect(0, 0, 499, 499);
    return layer.get();
  }

  //Red line on top of the graph screen allowing the user to select a particular dataPoint
  public void previewLine(float mX, float mY) {
    if (mX >= x && mX <= x + 500 && mY >= y && mY <= y + 500) {
      stroke(120, 0, 0, 150);
      line(mX, y, mX, y + 500);
      stroke(0, 255);
      this.selected = occurences[min(occurences.length-1, round((sb.scrollValue() + mX - x) / 50))];
    } else this.selected = null;
  }

  //Method to select the item under the cursor from the list screen
  public void listCursor(float mX, float mY) {
    if (mX >= x && mX <= x + 500 && mY >= y + 50 && mY <= y + 500) {
      this.selected = occurences[min(occurences.length-1, floor((sb.scrollValue() + mY - y - 50) / 50))];
    } else this.selected = null;
  }

  //Small box next to the data box, displaying the selected item briefly
  public void previewBox() {
    fill(255);
    stroke(0, 255);
    rect(x + 510, y, 200, 100);
    fill(0);
    textSize(24);
    textAlign(CENTER, TOP);
    text(subject.toString(), x + 610, y);
    textSize(14);
    textAlign(LEFT, CENTER);
    text("Amount :", x + 530, y + 65);
    text("Date: ", x + 530, y + 45);
    if (selected != null) {
      text(selected.getKey().toString(), x + 600, y + 45);
      text(selected.getValue().toString(), x + 600, y + 65);
    }
  }

  public void draw() {
    int scrollValue = sb.scrollValue();
    if (listMode) {
      image(graph.get(0, scrollValue, 500, 450), x, y+50, 500, 450);
      image(layout, x, y, 500, 500);
      listCursor(mouseX, mouseY);

      //Small triangle to indicate the way in which the items are ordered
      float triangleOffset = sortByOccurence ? 465 : 315;
      pushMatrix();
      translate(x + triangleOffset, y + 5);
      fill(100, 0, 0);
      triangle(0, 0, 30, 0, 15, 20);
      popMatrix();
      
    } else {
      image(graph.get(scrollValue, 0, 500, 500), x, y, 500, 500);
      image(layout, x, y, 500, 500);
      previewLine(mouseX, mouseY);
    }
    fill(255);
    rect(x + 510, y + 200, 80, 40);
    fill(0);
    textSize(24);
    textAlign(CENTER, CENTER);
    text(listMode ? "Graph" : "List", x + 550, y + 220);

    sb.move();
    sb.draw();
    previewBox();
  }

  public void switchView() {
    listMode = !listMode;
    if (listMode) {
      int w = max(450, occurences.length * 50);
      sb = new Scrollbar(x, y+500, w, 450, 500);
      graph = getListImage(w + 50, occurences);
      layout = getListOverlay();
    } else {
      int w = max(500, occurences.length * 50 - 50);
      int h = step_length * step_amount;
      sb = new Scrollbar(x, y+500, w, 500, 500);
      graph = getGraphImage(w, h, Arrays.stream(occurences).mapToInt(Map.Entry::getValue).toArray());
      layout = getGraphOverlay(step_length, step_amount);
    }
    sb.scrolled(0, 0);
  }

  public void mousePressed() {
    if (mouseX >= x +510 && mouseX <= x + 590 && mouseY >= y + 200 && mouseY<= y + 240) switchView(); //The button to switch from list to graph and the other way around
    else if (listMode && mouseX >= x && mouseX <= x + 500 && mouseY >= y && mouseY<= y + 50) {        //The sorting interaction on the list view
      if (mouseX <= x + 350 && sortByOccurence) {
        sortByOccurence = !sortByOccurence;
        occurences = Arrays.stream(occurences).sorted((o1, o2) -> o1.getKey().compareTo(o2.getKey())).toArray(Map.Entry[]::new);
        listMode = !listMode;
        switchView();
      } else if (mouseX > x + 350 && !sortByOccurence) {
        sortByOccurence = !sortByOccurence;
        occurences = Arrays.stream(occurences).sorted((o1, o2) -> -1 * o1.getValue().compareTo(o2.getValue())).toArray(Map.Entry[]::new);
        listMode = !listMode;
        switchView();
      }
    }
    sb.pressed();
  }

  public void mouseReleased() {
    sb.released();
  }

  public void mouseWheel(float e) {
    if (mouseX >= x && mouseX <= x + 500 && mouseY >= y && mouseY <= y + 500)
      sb.scrolled(e, -1);
  }
}
