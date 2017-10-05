public class SketchTanaka extends AppBase {

  FloatList locX = new FloatList();
  FloatList locY = new FloatList();

  public SketchTanaka(PApplet parentApplet) {
    super(parentApplet);
    background(0);
  }

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    frameRate(20);
    //FloatList locX = new FloatList();
    //FloatList locY = new FloatList();
    background(0);

    locX.clear();
    locY.clear();
    locX.append(random(200, width-200));
    locY.append(random(200, height-200));
  }

  @Override void draw() {
    background(0);
    float en = random(1, 10);
    float light = random(240, 255);

    fill(light);
    noStroke();

    //ellipse(mouseX, mouseY, en, en);

    for (int i = 0; i < locX.size(); i++) {
      ellipse(locX.get(i), locY.get(i), en, en);
    }

    stroke(255, 255, 255, 95);
    noFill();

    for (int i = 0; i < locX.size()-1; i++) {
      line(locX.get(i), locY.get(i), locX.get(i+1), locY.get(i+1));
    }

    //auto play mode
    if(frameCount % 30 == 0){
      locX.append(random(200, width-200));
      locY.append(random(200, height-200));
    }
  }

 /*
  @Override void mouseReleased() {
    locX.append(mouseX);
    locY.append(mouseY);
  }
  */
}