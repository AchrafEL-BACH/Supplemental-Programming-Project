import java.lang.reflect.Method;
import java.util.ArrayDeque;

// I didn't comment the timestamp of every modification I have done because it's a solo project and it would have messed up the readability of the code too much (and I only work on the project on Thursday night to Friday morning)

final int OBJECTS_SHOWN = 1000;
final int WINDOW_WIDTH = 1000;
final int WINDOW_HEIGHT = 700;

ArrayDeque<Screen> history;  //Deque storing the user screens path to efficiently return to the previous screen
Screen display;              //Abstract recipient responsible of the window display
SaleInfo[] sales;            //The list of sales in an appropriate format. Array is used because the size is finite
ParsingTool pt;              //The tool responsible of transforming the text/data file into a list of usable objects

String command;          //Recipient for the screen change
boolean oneFrameDelay;   //Only exists to delay the screen change of one frame in order to display a loading screen during long processing times

void settings() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT);
}

public void setup() {
  textFont(loadFont("CalifornianFB-Reg-48.vlw"));
  pt = new ParsingTool("receipts.tsv");
  history = new ArrayDeque();          
  display = new MenuScreen(0, 0);
  command = null;
  oneFrameDelay = false;
}

void draw() {
  background(204, 238, 255);
  display.draw();

  if (command != null) {    //When the user send a request to change screen he first faces a loading screen that lasts from one frame to bigger amounts
    if (oneFrameDelay) {
      float centerX = width/2, centerY = height/2;
      fill(180, 255, 180);
      rect(centerX - 200, centerY - 100, 400, 200);
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(100);
      text("Loading", centerX, centerY);
      oneFrameDelay = false;
    } else {
      changeScreen(command);  //Method processing the change screen request
      command = null;
    }
  }
}
void mouseWheel(MouseEvent event) {
  float scroll = event.getCount();
  display.mouseWheel(scroll);
}

void mousePressed() {
  command = display.mousePressed();        //Every screen has the ability to return a request to change screen
  if (command != null) oneFrameDelay = true;
}

public void mouseReleased() {
  display.mouseReleased();
}

void changeScreen(String command) {
  if (command != null) {
    String[] response = command.split("->");
    switch(response[0]) {
    case "SELECTION":                  //Choice of a list display with images for each items
      history.addFirst(display);
      if (response[1].equals("CUSTOMERS")) {
        String store = response.length > 2 ? response[2] : "";
        display = store!="" ? new SelectionScreen(0, 0, pt.get_storeCustomerList(store), store) : new SelectionScreen(0, 0, pt.get_customers());
      } else if (response[1].equals("STORES")) {
        display = new SelectionScreen(0, 0, pt.get_stores());
      } else if (response[1].equals("PRODUCTS")) {
        display = new SelectionScreen(0, 0, pt.get_products());
      }
      break;
    case "GRAPH":                      //Choice of a graph/list representation of the occurences of an attribute over another attribute
    case "LIST":                       //Choice to represent a display of item lists for each dates available
      history.addFirst(display);

      String subject = response[0].equals("GRAPH") ? "POPULAR " + response[1] : "PURCHASE HISTORY";
      for (int i = 2; i < response.length; i++) {
        String[] filter = response[i].split(":");
        switch(filter[0]) {
        case "CUSTOMER":
          String customer = filter[1];
          FilteringTool.setCustomerFilter(customer);
          subject = customer + "'s " + subject;
          break;
        case "STORE":
          String store = filter[1];
          FilteringTool.setStoreFilter(store);
          subject = subject + " in " + store;
          break;
        default:
          break;
        }
      }
      if (response[0].equals("GRAPH")) {
        int occurenceKey = new ArrayList<String>() {
          {
            add("CUSTOMER");
            add("STORE");
            add("DATE");
            add("PRODUCT");
          }
        }
        .indexOf(response[1]);
        display = new GraphScreen(0, 0, FilteringTool.getFilterResults(pt.get_sales()), occurenceKey, subject);
      } else {
        display = new SaleScreen(0, 0, FilteringTool.getFilterResults(pt.get_sales(), SortingTool.sortBy(SortingTool.DATE)), subject);
      }
      break;
    case "TIME":                       //Choice of a list representation of the popularity of an item over time
      history.addFirst(display);
      ArrayList<String> attributes = new ArrayList<String>() {
        {
          add("CUSTOMER");
          add("STORE");
          add("DATE");
          add("PRODUCT");
        }
      };
      FilteringTool.setProductFilter(response[3]);
      display = new GraphScreen(0, 0, FilteringTool.getFilterResults(pt.get_sales()), attributes.indexOf(response[1]), attributes.indexOf(response[2]), response[3], response[3] + " POPULARITY BY " + response[1]);

      break;
    case "BACK":                       //Choice to return to the previous screen
      display = history.pop();
      break;
    default:
      break;
    }
  }
}
