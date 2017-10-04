public class SketchFujii extends AppBase {

  PImage img;

  public SketchFujii(PApplet parentApplet) {
    super(parentApplet);
  }

  @Override
    void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    frameRate(60);
    img = loadImage("fujii.jpg");
    img.resize(width, height);
    background(0);
    noStroke();
    rectMode(CENTER);
  }

  @Override
    void draw() {
    for (int i=0; i<100; i++) {
      int x = int(random(width));
      int y = int(random(height));
      color col =img.get(x, y);
      fill(col, 127);
      pushMatrix();
      translate(x, y);
      rotate(map(hue(col), 0, 255, 0, PI));
      float w = map(saturation(col), 0, 255, 1, 40);
      rect(0, 0, w, 1.5);
      popMatrix();
    }
  }
}
