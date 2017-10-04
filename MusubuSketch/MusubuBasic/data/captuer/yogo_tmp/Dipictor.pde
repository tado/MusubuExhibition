class Dipictor {
  public ArrayList<ImageContainer> images;
  ArrayList<Partial> partials;
  PImage target;
  
  int xUnit;
  int yUnit;
  
  final int GRID = 130;
  
  Dipictor() {
    images = new ArrayList<ImageContainer>();
    partials = new ArrayList<Partial>();
  }
  
  void addImage(ImageContainer img) {
    this.images.add(img);
  }
  
  void setTarget(PImage target) {
    target.resize(width, height);
    this.target = target;
  }
  
  void changeTarget(ImageContainer target){
    this.setTarget(target.img);
    this.partials.clear();
    this.createPartials();
  }

  void createPartials() {
    target.loadPixels();
    xUnit = int(width / GRID);
    yUnit = int(height / GRID);
    for (int y = 0; y < target.height; y+=yUnit) {
      for (int x = 0; x < target.width; x+=xUnit) {
        PImage sourceImage = createImage(xUnit, yUnit, RGB);
        PVector pos = new PVector(x, y);
        ImageContainer sourceImageContainer = copyPixels(sourceImage, x, y);
        Partial partial = new Partial(sourceImageContainer, pos);
        ImageContainer material = this.pickFittestImage(sourceImageContainer);
        partial.setMaterial(material);
        partials.add(partial);
      }
    }
  }

  ImageContainer copyPixels(PImage subImage, int x, int y) {
    subImage.loadPixels();
    for (int _y = 0; _y < yUnit; _y++) {
      for (int _x = 0; _x < xUnit; _x++) {
        int index = _x + (_y * xUnit);
        subImage.pixels[index] = target.get(x+_x, y+_y);
      }
    }
    subImage.updatePixels();
    ImageContainer subImageContainer = new ImageContainer(subImage);
    subImageContainer.calcColor();
    return subImageContainer;
  }

  ImageContainer pickFittestImage(ImageContainer sourceImage) {
    float minimum = 1000000000;
    int foundIndex = 0;
    for(int i = 0; i < this.images.size(); i++){
      ImageContainer img = this.images.get(i);
      float dist = img.imgVector.dist(sourceImage.imgVector);
      if(dist < minimum){
        minimum = dist;
        foundIndex = i;
      }
    }
    ImageContainer material;
    try{
      material = this.images.get(foundIndex);
    }catch(IndexOutOfBoundsException e){
      material = new ImageContainer(createImage(xUnit, yUnit, RGB));
    }
    
    return material;
  }
  void updatePartials() {
    for(Partial part : partials){
      ImageContainer material = this.pickFittestImage(part.sourceImage);
      part.setMaterial(material);
    }
  }
  void showPartials() {
    for (Partial part : partials) {
      part.show();
    }
    //for(int i = 0; i <partials.size(); i++){
    //  if(random(100) > 50){
    //    partials.get(i).show();
    //  }
    //}
  }

  void showTarget() {
    image(target, 0, 0);
  }

  void showGallery() {
    for (int i = 0; i < this.images.size(); i++) {
      ImageContainer imgContainer = this.images.get(i);
      int xIndex = i % GRID;
      int yIndex = floor(i/GRID);
      float x = xIndex * (width/GRID);
      float y = yIndex * (height/GRID);
      imgContainer.show(x, y);
      //imgContainer.showRect(x, y);
    }
  }
}