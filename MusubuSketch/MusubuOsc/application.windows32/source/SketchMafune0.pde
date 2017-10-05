public class SketchMafune extends AppBase {

  int num = 10000;
  int frames = 150;
  float theta;
  PImage img;

  public SketchMafune(PApplet parentApplet) {
    super(parentApplet);
    img = loadImage("mafune0.jpg");
  }

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    frameRate(60);
    //tint(150);
    img.filter(BLUR, 1);
  }

  @Override void draw() {
    tint(150);
    image(img, 0, 0, width, height);
    randomSeed(5000);
    noStroke();

    fill(0);
    ellipse(width/2.0, height/2.0, 300, 300);

    translate(width/2.0, height/2.0);
    for (int i=0; i<num; i++) {
      pushMatrix();
      float r = random(TWO_PI);
      rotate(r);
      float s = 300/2.0;
      float d =  random(s-5, height*.50);
      float x = map(sin(theta+random(TWO_PI)), -1, 1, s, d);
      float sz = random(0.1, 3);
      fill(255, 100);
      ellipse(x, 0, sz, sz);
      popMatrix();
    }
    theta += TWO_PI/frames;
    //if (frameCount<=frames) saveFrame("image-###.gif");

    noTint();
  }
}