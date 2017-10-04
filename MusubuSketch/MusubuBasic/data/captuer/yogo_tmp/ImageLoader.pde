class ImageLoader extends Thread {
  String imgURL;
  final int GRID = 130;
  Dipictor dipictor;
  
  ImageLoader(String imgURL, Dipictor _dipictor) {
    this.imgURL = imgURL;
    dipictor = _dipictor;
  }
  public void run() {
    //println("loading");
    try {
      PImage img = loadImage(imgURL);
      img.resize(width/GRID, height/GRID);
      ImageContainer imgContainer = new ImageContainer(img);
      imgContainer.calcColor();
      dipictor.addImage(imgContainer);
      //println("Done Loading", dipictor.images.size());
    }
    catch(NullPointerException e) {
      println("NULLPO");
    }
  }
}