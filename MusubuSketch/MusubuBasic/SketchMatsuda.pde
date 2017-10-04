public class SketchMatsuda extends AppBase {

  PImage img;

  public SketchMatsuda(PApplet parentApplet) {
    super(parentApplet);
  }

  @Override
    void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    frameRate(60);
    img = loadImage("matsuda.jpg");
    img.resize(width, height);
    background(0);
  }

  @Override
    void draw() {
    for (int i = 0; i < 100; i++) {
      noStroke();
      int x = int(random(width));
      int y = int(random(height));
      color col = img.get(x, y);
      fill(col);
      rectMode(CENTER);
      pushMatrix();
      rect(x, y, 30, 30);
      popMatrix();
    }
  }
}
