public class SketchBase extends AppBase {

  PImage img;

  public SketchBase(PApplet parentApplet) {
    super(parentApplet);
  }

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    frameRate(60);
  }

  @Override void draw() {

  }
}
