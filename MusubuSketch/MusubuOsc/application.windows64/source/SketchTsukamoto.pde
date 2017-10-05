public class SketchTsukamoto extends AppBase {

  int barWidth = 20;
  int lastBar = -1;

  public SketchTsukamoto(PApplet parentApplet) {
    super(parentApplet);
  }

  @Override void setup() {
    frameRate(60);
    colorMode(HSB, width, height, 100);
    noStroke();
    rectMode(CORNER);
    background(0);
  }

  @Override void draw() {
    //autoplay mode
    int whichBar = int(sin(frameCount/20.0) * width/2 + width/2) / barWidth;
    //int whichBar = mouseX / barWidth;
    if (whichBar != lastBar) {
      int barX = whichBar * barWidth;
      //fill(barX, mouseY, 66);
      fill(barX, random(190,255), 66);
      rect(barX, 0, barWidth, height);
      lastBar = whichBar;
    }
  }
}