public class SketchIndex {
  int col = 6;
  int row = 2;
  MusubuOsc parentApplet;
  MenuRectButton menuButton[] = new MenuRectButton[row * col];
  public SketchIndex(MusubuOsc _parentApplet){
    parentApplet = _parentApplet;

    int buttonWidth = width / col;
    int buttonHeight = height / row / 2;
    for(int j = 0; j < row; j++){
      for(int i = 0; i < col; i++){
        menuButton[j * col + i] = new MenuRectButton(parentApplet, buttonWidth * i, height / 2 + buttonHeight * j, buttonWidth, buttonHeight, j * col + i);
      }
    }
  }

  void draw(){
    background(0);
    colorMode(RGB, 255, 255, 255, 255);
    noTint();
    fill(255);
    text("Main Menu", 20, 20);
    for(int i = 0; i < row*col; i++){
      menuButton[i].draw();
    }
  }

  void mouseReleased(){
    for(int i = 0; i < row*col; i++){
      menuButton[i].mouseReleased();
    }
  }

  void mouseMoved(){
    for(int i = 0; i < row*col; i++){
      menuButton[i].mouseMoved();
    }
  }
}

public class MenuRectButton {
  int x, y, rwidth, rheight, index;
  boolean rollOvered;
  MusubuOsc parentApplet;
  public MenuRectButton(MusubuOsc _parentApplet, int _x, int _y, int _width, int _height, int _index){
    x = _x;
    y = _y;
    rwidth = _width;
    rheight = _height;
    index = _index;
    parentApplet = _parentApplet;
    rollOvered = false;
  }

  void draw(){
    rectMode(CORNER);
    strokeWeight(1);

    if(rollOvered){
      stroke(200);
      fill(127);
    } else {
      stroke(127);
      noFill();
    }
    rect(x, y, rwidth, rheight);
  }

  void mouseReleased(){
    if(mouseX > x
      && mouseX < x + rwidth
      && mouseY > y
      && mouseY < y + rheight
      ){
        parentApplet.setSketch(index);
      }
  }

  void mouseMoved(){
    if(mouseX > x
      && mouseX < x + rwidth
      && mouseY > y
      && mouseY < y + rheight
      ){
        rollOvered = true;
      } else {
        rollOvered = false;
      }
  }
}