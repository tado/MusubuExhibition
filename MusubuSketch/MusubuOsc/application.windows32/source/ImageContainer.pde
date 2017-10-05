class ImageContainer {
  public PImage sourceImage;
  public PImage resizedImage;
  public PVector imgVector;
  int GRID = 10;

  ImageContainer(PImage sourceImg) {
    this.sourceImage = sourceImg;
  }

  void calcColor() {
    this.resizeImage();
    resizedImage.loadPixels();
    int dimension = resizedImage.width * resizedImage.height;
    int sumRed = 0;
    int sumGreen = 0;
    int sumBlue = 0;
    for(int i = 0; i < dimension; i++){
      color c = resizedImage.pixels[i];
      sumRed += red(c);
      sumGreen += green(c);
      sumBlue += blue(c);
    }
    float red = sumRed / dimension;
    float green = sumGreen / dimension;
    float blue = sumBlue / dimension;
    this.imgVector = new PVector(red, green, blue);
  }
  void resizeImage() {
    this.resizedImage = copyImage(this.sourceImage);
    this.resizedImage.resize(width/GRID, height/GRID);
  }
  void show(float x, float y) {
    image(this.resizedImage, x, y);
  }
  void showRect(float x, float y){
    fill(imgVector.x, imgVector.y, imgVector.z);
    rect(x, y, this.resizedImage.width, this.resizedImage.height);
  }
}