//The screen implementation containing the GRAPH request/ the graph over time/attribute
class GraphScreen extends Screen {
  GraphList gl;
  String topic;
  
  GraphScreen(float x, float y, SaleInfo[] sales, int occurenceKey, String subject){
    super(x,y);
    this.topic = subject;
    this.gl = new GraphList(100, 150, sales, occurenceKey, "Graph");
  }
  
  GraphScreen(float x, float y, SaleInfo[] sales, int occurenceKey, int occurenceValue, String value, String subject){
    super(x,y);
    this.topic = subject;
    this.gl = new GraphList(100, 150, sales, occurenceKey, occurenceValue, value);
  }
  
  void draw(){
    this.gl.draw();
    fill(0);
    textAlign(LEFT, TOP);
    textSize(min(50, 2000/topic.length()));
    text(topic, 50, 10);
    
    super.draw();
  }
  
  String mousePressed(){
    this.gl.mousePressed();
    return super.mousePressed();
  }
  
  void mouseWheel(float e){
    this.gl.mouseWheel(e);
  }
  
  void mouseReleased(){
    this.gl.mouseReleased();
  }
}
