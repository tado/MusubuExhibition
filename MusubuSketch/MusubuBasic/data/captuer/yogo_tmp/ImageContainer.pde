class ImageContainer {
  public PImage img;
  public PVector imgVector;
  ImageContainer(PImage img) {
    this.img = img;
  }
  void calcColor() {
    PImage img = this.img;
    img.loadPixels();
    int dimension = img.width * img.height;
    int sumRed = 0;
    int sumGreen = 0;
    int sumBlue = 0;
    for(int i = 0; i < dimension; i++){
      color c = img.pixels[i];
      sumRed += red(c);
      sumGreen += green(c);
      sumBlue += blue(c);
    }
    float red = sumRed / dimension;
    float green = sumGreen / dimension;
    float blue = sumBlue / dimension;
    this.imgVector = new PVector(red, green, blue);
  }
  void show(float x, float y) {
    image(this.img, x, y);
  }
  void showRect(float x, float y){
    fill(imgVector.x, imgVector.y, imgVector.z);
    rect(x, y, this.img.width, this.img.height);
  }
}