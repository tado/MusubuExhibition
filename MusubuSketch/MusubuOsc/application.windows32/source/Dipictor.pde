class Dipictor {
  public ArrayList<ImageContainer> images;
  ArrayList<Partial> partials;
  PImage target;
  int xUnit;
  int yUnit;
  //int GRID = 10;
  SketchYogo parent;

  Dipictor(SketchYogo _parent) {
    parent = _parent;
    xUnit = int(width / parent.GRID);
    yUnit = int(height / parent.GRID);
    images = new ArrayList<ImageContainer>();
    partials = new ArrayList<Partial>();
  }

  void addImage(ImageContainer img) {
    this.images.add(img);
  }

  void setTarget(PImage target) {
    this.target = target;
    this.target.resize(width, height);
  }

  void changeTarget(ImageContainer target) {
    this.setTarget(target.sourceImage);
    this.resetPartials();
  }

  void resetPartials() {
    this.partials.clear();
    this.createPartials();
  }

  void updateGRID() {
    this.xUnit = floor(width / parent.GRID);
    this.yUnit = floor(height / parent.GRID);
    this.resetPartials();
    this.resizeImages();
  }
  void resizeImages(){
    for(int i = 0; i < this.images.size(); i++){
      this.images.get(i).resizeImage();
    }
  }

  void createPartials() {
    this.target.loadPixels();
    for (int y = 0; y < target.height; y+=yUnit) {
      for (int x = 0; x < target.width; x+=xUnit) {
        PImage sourceImage = createImage(xUnit, yUnit, RGB);
        PVector pos = new PVector(x, y);
        ImageContainer sourceImageContainer = this.copyPixels(sourceImage, x, y);
        Partial partial = new Partial(sourceImageContainer, pos);
        ImageContainer material = this.pickFittestImage(sourceImageContainer);
        partial.setMaterial(material);
        partials.add(partial);
      }
    }
  }

  void updatePartials() {
    for (Partial part : partials) {
      ImageContainer material = this.pickFittestImage(part.sourceImage);
      part.setMaterial(material);
    }
  }

  ImageContainer copyPixels(PImage sourceImage, int x, int y) {
    sourceImage.loadPixels();
    for (int _y = 0; _y < yUnit; _y++) {
      for (int _x = 0; _x < xUnit; _x++) {
        int index = _x + (_y * xUnit);
        sourceImage.pixels[index] = target.get(x+_x, y+_y);
      }
    }
    sourceImage.updatePixels();
    ImageContainer sourceImageContainer = new ImageContainer(sourceImage);
    sourceImageContainer.calcColor();
    return sourceImageContainer;
  }

  ImageContainer pickFittestImage(ImageContainer sourceImage) {
    float minimum = 1000000000;
    int foundIndex = 0;
    for (int i = 0; i < this.images.size(); i++) {
      ImageContainer img = this.images.get(i);
      try {
        float dist = img.imgVector.dist(sourceImage.imgVector);
        if (dist < minimum) {
          minimum = dist;
          foundIndex = i;
        }
      }
      catch(NullPointerException e) {
      }
    }
    ImageContainer material;
    try {
      material = this.images.get(foundIndex);
    }
    catch(IndexOutOfBoundsException e) {
      material = new ImageContainer(createImage(xUnit, yUnit, RGB));
    }
    return material;
  }
  void showPartials() {
    for (Partial part : partials) {
      try {
        part.show();
        //part.showRect();
      }
      catch(NullPointerException e) {
      }
    }
  }

  void showTarget() {
    image(target, 0, 0);
  }

  void showGallery() {
    for (int i = 0; i < this.images.size(); i++) {
      ImageContainer imgContainer = this.images.get(i);
      int xIndex = i % parent.GRID;
      int yIndex = floor(i/parent.GRID);
      float x = xIndex * (width/parent.GRID);
      float y = yIndex * (height/parent.GRID);
      imgContainer.show(x, y);
      //imgContainer.showRect(x, y);
    }
  }
}