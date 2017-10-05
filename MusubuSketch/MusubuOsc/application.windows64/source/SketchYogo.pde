public class SketchYogo extends AppBase {
  Dipictor dipictor;
  int targetID = 1;
  int GRID = 10;
  String path = sketchPath();
  int GALLERY_SIZE;

  public SketchYogo(PApplet parentApplet) {
    super(parentApplet);
    
    dipictor = new Dipictor(this);
    File dir= new File(dataPath("yogo"));
    File [] files= dir.listFiles();
    GALLERY_SIZE = files.length;
    for (int i = 0; i < files.length; i++) {
      String imgURL = files[i].getName();
      //println(imgURL);
      if (i == 0) {
        PImage target = loadImage("data/yogo/" + imgURL);
        dipictor.setTarget(target);
        dipictor.createPartials();
      } else {
        //PImage img = loadImage(imgURL);
        PImage img = loadImage("data/yogo/" + imgURL);
        ImageContainer imgContainer = new ImageContainer(img);
        imgContainer.calcColor();
        dipictor.addImage(imgContainer);
      }
    }
  }

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    frameRate(60);

    targetID = 1;
    GRID = 10;
  }

  boolean shouldShowTarget = false;
  @Override void draw() {
    background(0);

    dipictor.updatePartials();

    if (shouldShowTarget) {
      dipictor.showTarget();
    } else {
      dipictor.showPartials();
    }
    if (frameCount % 5 == 0) {
      updateGallery();
    }
  }

  /*
  @Override void mousePressed() {
   shouldShowTarget = !shouldShowTarget;
   }
   */

  void updateGallery() {
    //if (GRID > 150) {
    if (GRID > 80) {
      GRID = 10;
      dipictor.updateGRID();
      switchPhoto();
    } else {
      GRID = floor(GRID * 1.5);
      dipictor.updateGRID();
    }
  }

  void switchPhoto() {
    if (targetID < GALLERY_SIZE-2) {
      targetID++;
    } else {
      targetID = 0;
    }
    ImageContainer target = dipictor.images.get(targetID);
    dipictor.changeTarget(target);
  }
  void keyPressed() {
    try {
      if (keyCode == RIGHT) {
        targetID++;
        ImageContainer target = dipictor.images.get(targetID);
        dipictor.changeTarget(target);
      }
      if (keyCode == LEFT) {
        if (targetID > 0) {
          targetID--;
          ImageContainer target = dipictor.images.get(targetID);
          dipictor.changeTarget(target);
        }
      }
    }
    catch(IndexOutOfBoundsException e) {
    }
    if (keyCode == UP) {
      if (GRID < 150) {
        GRID = floor(GRID * 1.5);
        dipictor.updateGRID();
      }
    }
    if (keyCode == DOWN) {
      if (GRID > 5) {
        GRID = floor(GRID / 1.5);
        dipictor.updateGRID();
      }
    }
  }
}