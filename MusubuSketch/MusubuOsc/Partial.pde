class Partial {
  PVector pos;
  public ImageContainer sourceImage;
  ImageContainer materialImage;
  Partial(ImageContainer sourceImage,  PVector pos) {
    this.sourceImage = sourceImage;
    this.pos = pos;
  }
  void setMaterial(ImageContainer materialImage){
    this.materialImage = materialImage;
  }
  void show() {
    this.materialImage.show(pos.x, pos.y);
  }
  void showRect(){
    this.materialImage.showRect(pos.x, pos.y);
  }
}