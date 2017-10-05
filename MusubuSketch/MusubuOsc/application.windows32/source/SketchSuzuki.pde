public class SketchSuzuki extends AppBase {

  PImage img;

  public SketchSuzuki(PApplet parentApplet) {
    super(parentApplet);
  }

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    frameRate(60);
    rectMode(CENTER);
    background(0);
  }

  @Override void draw() {
    fill(20, 10);
    rect( width/2, height/2, width, height);
    rect( width/2, height/2, width, height);

    fill(random(200, 255), random(200, 255), random(200, 255));
    ellipse(random(width), random(height), random(5, 10), random(5, 10));
    noStroke();
    rect(width/2, height/2, 100, 200);
  }
}