//import http.requests.*;
SketchIndex index;
//creating a list of our apps
ArrayList<AppBase> apps;
int selected;

void setup() {
  fullScreen(2);
  //size(1920, 1080);
  //size(1280, 720);

  //Index (menu)
  index = new SketchIndex(this);

  //creating an instance of our list
  apps = new ArrayList<AppBase>();

  //adding each of our nested Applets to the list.
  apps.add(new SketchFujii(this));
  apps.add(new SketchMatsuda(this));
  apps.add(new SketchSuzuki(this));
  apps.add(new SketchKamiya(this));
  apps.add(new SketchTanaka(this));
  apps.add(new SketchTsukamoto(this));
  apps.add(new SketchMafune(this));
  apps.add(new SketchHanda(this));
  apps.add(new SketchKim(this));
  apps.add(new SketchYogo(this));
  apps.add(new SketchMorimoto(this));

  /*
  for (AppBase a : apps) {
   a.setup();
   }
   */

  selected = -1;
  //apps.get(selected).setup();
}

void draw() {
  if(selected == -1){
    index.draw();
  }
  if(selected >= 0){
    apps.get(selected).draw();
    apps.get(selected).mouseX = mouseX;
    apps.get(selected).mouseY = mouseY;
  }
}

void mouseDragged() {
  if(selected >= 0){
    apps.get(selected).mouseDragged();
  }
}

void mousePressed() {
  if(selected >= 0){
    apps.get(selected).mousePressed();
  }
}

void mouseMoved() {
  if(selected == -1){
    index.mouseMoved();
  }
}

void mouseReleased() {
  if(selected == -1){
    index.mouseReleased();
  }
  if(selected >= 0){
    if(mouseX < 100 && mouseY < 100){
      selected = -1;
    } else {
      apps.get(selected).mouseReleased();
    }
  }
}

/**
 * Here we use key presses to determine which
 * app to display.
 **/
void keyPressed() {
  background(0);
  if (key == '0') {
    selected = 0;
  }
  if (key == '1') {
    selected = 1;
  }
  if (key == '2') {
    selected = 2;
  }
  if (key == '3') {
    selected = 3;
  }
  if (key == '4') {
    selected = 4;
  }
  if (key == '5') {
    selected = 5;
  }
  if (key == '6') {
    selected = 6;
  }
  if (key == '7') {
    selected = 7;
  }
  if (key == '8') {
    selected = 8;
  }
  if (key == '9') {
    selected = 9;
  }
  if (key == 'a') {
    selected = 10;
  }
  apps.get(selected).setup();
}

void setSketch(int n){
  selected = n;
  apps.get(selected).setup();
}