public class SketchKim extends AppBase {

  PImage img;
  int cellsize = 6;
  int cols, rows;
  int x, y;
  color c;
  float sz;
  float noiseOff1 = 4;
  float noiseOff2 = 0;

  public SketchKim(PApplet parentApplet) {
    super(parentApplet);

    img = loadImage("kim.jpg");
    img.resize(width, height);
  }

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    frameRate(20);
    cols = width/cellsize;
    rows = height/cellsize;
  }

  @Override void draw() {
    background(0);

    img.loadPixels();

    // Begin loop for columns
    for (int i = 0; i < cols; i++ ) {
      for (int j = 0; j < rows; j++ ) {
        int x = i*cellsize + cellsize/2; // x position
        int y = j*cellsize + cellsize/2; // y position
        int loc = x + y * width;         // Pixel array location
        color c = img.pixels[loc];       // Grab the color
        float sz = (saturation(c)/255) * cellsize;

        pushMatrix();
        float n1 = constrain(noise(noiseOff1) + 0.6, 0, 1);
        float n2 = noise(noiseOff2);
        fill(blue(c) * n1, green(c) * n2, red(c) * n1);
        noStroke();
        ellipseMode(CENTER);
        ellipse(x, y, sz, sz);
        noiseOff1 = noiseOff2 + 0.1;
        if (noiseOff1 > 50000) {
          noiseOff1 = 4;
        }
        noiseOff2 = noiseOff2 + 0.2;
        if (noiseOff2 > 50000) {
          noiseOff2 = 0;
        }
        popMatrix();
        //noiseOff1 = 0;
      }
    }
  }
}