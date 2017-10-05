public class SketchKamiya extends AppBase {

  int NUM = 100; 
  PVector[] location = new PVector[NUM];
  PVector[] velocity = new PVector[NUM];

  public SketchKamiya(PApplet parentApplet) {
    super(parentApplet);
  }

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    frameRate(60);
    float diameter = random(100);
    noStroke(); 
    fill(random(255), random(255), random(255)); 
    ellipse(random(width), random(height), diameter, diameter);
    for (int i = 0; i < NUM; i++) { 
      location[i] = new PVector(random(width), random(height));
      velocity[i] = new PVector(random(10), random(10));
    }
  }

  @Override void draw() {
    background(150); 
    for (int i = 0; i < NUM; i++) { 
      float diameter = random(375);
      noStroke(); 
      fill(random(1000), random(1000), random(1000)); 
      ellipse(random(width), random(height), diameter, diameter);
      location[i].add(velocity[i]);
      if ((location[i].x > width) || (location[i].x < 0)) {
        velocity[i].x *= -1;
      }
      if ((location[i].y > height) || (location[i].y < 0)) {
        velocity[i].y *= -1;
      }
    }
  }
}