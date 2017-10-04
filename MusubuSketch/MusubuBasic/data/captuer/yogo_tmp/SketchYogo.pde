public class SketchYogo extends AppBase {

  Dipictor dipictor;
  APIHandler apiHandler;
  final int GRID = 130;
  final int IMG_PER_PAGE = 200;
  final int PAGES = 3;
  final String keyword = "wolf";
  int targetID = 10;

  public SketchYogo(PApplet parentApplet) {
    super(parentApplet);
  }

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    frameRate(60);
    dipictor = new Dipictor();
    apiHandler = new APIHandler(dipictor);
    ArrayList<String> imgURLs = apiHandler.search("&orientation=horizontal&image_type=photo" + "&q=" + keyword + "&per_page=" + str(IMG_PER_PAGE));
    for (int i = 0; i < imgURLs.size(); i++) {
      String imgURL = imgURLs.get(i);
      boolean isTarget = i == targetID;
      apiHandler.load(imgURL, isTarget);
    }
  }

  boolean flag = false;
  @Override void draw() {
    background(0);
    if (frameCount % 60 == 0) {
      dipictor.updatePartials();
    }
    if (flag) {
      dipictor.showTarget();
    } else {
      dipictor.showPartials();
    }
  }

  @Override void mousePressed() {
    flag = !flag;
    //targetID++;
    //ImageContainer target = dipictor.images.get(targetID);
    //dipictor.changeTarget(target);
  }
}