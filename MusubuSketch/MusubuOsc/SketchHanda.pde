public class SketchHanda extends AppBase {

  PImage img, img_mask;
  float frame = 0.;
  float dur = 50.;
  float x=0.;
  int SQSIZE = 10;
  //boolean edgflg[][] = new boolean[1280][720];
  float cSize_pub[][] = new float[width/SQSIZE][height/SQSIZE];
  float cSize_pub_lt[][] = new float[width/SQSIZE][height/SQSIZE];
  float y=0;
  int imgnum=0;
  int imgqt =10;
  public SketchHanda(PApplet parentApplet) {
    super(parentApplet);

    img = loadImage("handa/image"+str(imgnum)+".jpg");
    img.resize(width, height);
  }

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    frameRate(60);
    //img_mask = createImage(1280,720, RGB);

    //image(img_mask, 0, 0, 1280,720);
    boolean flg[][] = edge(img);
    cSize_pub = pixelate(flg);
    fill(255, 255, 255);
    //draw(flg, cSize);
  }

  @Override void draw() {
    if (frame==0.&&y==0.) {
      img = loadImage("handa/image"+str(imgnum%imgqt)+".jpg");
      img.resize(width, height);
      //image(img_mask, 0, 0, 1280,720);
      boolean flg[][] = edge(img);
      cSize_pub = pixelate(flg);
      frame = (sin(-0.5*PI+PI*x/(dur))+1)*0.5;
      background(0);
      tint(255.0, 255.*(1-frame));
      image(img, 0, 0);
      fill(255, 255, 255);
      x += 1.;
    } else if (frame<1. && y==0) {
      background(0);
      tint(255.0, 255.*(1-frame));
      image(img, 0, 0);
      drawEdge(cSize_pub);
      frame = (sin(-0.5*PI+PI*x/(dur))+1)*0.5;
      x += 1.;
      //print(str(frame)+"\n");
    } else if (frame>0.98 && y==0.) {
      imgnum++;
      img = loadImage("handa/image"+str(imgnum%imgqt)+".jpg");
      img.resize(width, height);
      boolean flg[][] = edge(img);
      cSize_pub_lt = pixelate(flg);
      y++;
      //print(str(frame)+"\n");
    } else if (y == 1. && frame>0.01) {
      //print("*****************************");
      drawEdgeChng(cSize_pub, cSize_pub_lt);
      frame = (sin(-0.5*PI+PI*x/(dur))+1)*0.5;
      //print(frame+"\n");
      x += 1.;
    } else if (y==1. && frame <= 0.01) {
      //print("*****************************");
      drawEdge(cSize_pub_lt);
      y++;
      x += 1.;
    } else if (y==2. && 0.98>frame &&frame>=0.) {
      frame = (sin(-0.5*PI+PI*x/(dur))+1)*0.5;
      background(0);
      tint(255.0, 255.*frame);
      image(img, 0, 0);
      drawEdgeBack(cSize_pub_lt);
      x += 1.;
      //print("kokodayo");
      //print(str(frame)+"\n");
    } else if (y==2. && frame >0.98) {
      y=0;
      x=0;
      frame=0;
      //print("kitayo");
      //print(str(frame)+"\n");
    }
  }

  void drawEdge(float[][] cSize) {
    for (int j = 0; j < height; j += SQSIZE) {
      for (int i = 0; i < width; i += SQSIZE) {
        //img_mask.set(x, j, color(abs(g)*frame + red(col)*(1.0-frame),abs(g)*frame + green(col)*(1.0-frame),abs(g)*frame + blue(col)*(1.0-frame)));
        ellipse(i+SQSIZE/2, j+SQSIZE/2, SQSIZE*cSize[i/SQSIZE][j/SQSIZE]*frame, SQSIZE*cSize[i/SQSIZE][j/SQSIZE]);
      }
    }
  }

  void drawEdgeBack(float[][] cSize) {
    for (int j = 0; j < height; j += SQSIZE) {
      for (int i = 0; i < width; i += SQSIZE) {
        //img_mask.set(x, y, color(abs(g)*frame + red(col)*(1.0-frame),abs(g)*frame + green(col)*(1.0-frame),abs(g)*frame + blue(col)*(1.0-frame)));
        ellipse(i+SQSIZE/2, j+SQSIZE/2, SQSIZE*cSize[i/SQSIZE][j/SQSIZE]*(1-frame), SQSIZE*cSize[i/SQSIZE][j/SQSIZE]);
      }
    }
  }

  void drawEdgeChng(float[][] cSize, float[][] cSize_lt) {
    //print(str(frame)+"\n");
    for (int j = 0; j < height; j += SQSIZE) {
      for (int i = 0; i < width; i += SQSIZE) {
        //img_mask.set(x, y, color(abs(g)*frame + red(col)*(1.0-frame),abs(g)*frame + green(col)*(1.0-frame),abs(g)*frame + blue(col)*(1.0-frame)));

        ellipse(i+SQSIZE/2, j+SQSIZE/2, SQSIZE*cSize[i/SQSIZE][j/SQSIZE]*(frame)+SQSIZE*cSize_lt[i/SQSIZE][j/SQSIZE]*(1-frame), SQSIZE*cSize[i/SQSIZE][j/SQSIZE]*(frame)+SQSIZE*cSize_lt[i/SQSIZE][j/SQSIZE]*(1-frame));
      }
    }
  }

  boolean[][] edge(PImage input) {
    float gvs;
    float ghs;
    float g;
    color col;
    boolean edgflg[][] = new boolean[width][height];
    for (int j = 1; j < input.height-1; j++) {
      for (int i = 1; i < input.width-1; i++) {

        ghs = - red(input.get(i-1, j-1)) - 2*red(input.get(i-1, j)) - red(input.get(i-1, j+1)) + red(input.get(i+1, j-1)) + 2*red(input.get(i+1, j)) + red(input.get(i+1, j+1));
        gvs = - red(input.get(i-1, j-1)) - 2*red(input.get(i, j-1)) - red(input.get(i+1, j-1)) + red(input.get(i-1, j+1)) + 2*red(input.get(i, j+1)) + red(input.get(i+1, j+1));
        g = sqrt(pow(ghs, 2) + pow(gvs, 2));
        col = input.get(i, j);
        //print(g);
        if (g>127) {
          edgflg[i][j] = true;
        } else {
          edgflg[i][j] = false;
        }
      }
    }
    return edgflg;
  }

  float[][] pixelate(boolean[][] flg) {
    //float cSize[][] = new float[128][72];
    float cSize[][] = new float[width/SQSIZE][height/SQSIZE];
    for (int j = 0; j < height; j += SQSIZE) {
      for (int i = 0; i < width; i += SQSIZE) {
        //int cSize = 0;
        int wCnt = 0;
        for (int k=i; k<i+SQSIZE; k++) {
          for (int l=j; l<j+SQSIZE; l++) {
            if (flg[k][l]) {
              wCnt++;
            }
          }
        }
        if (wCnt>78) {
          cSize[i/SQSIZE][j/SQSIZE] = 1.;
        } else {
          cSize[i/SQSIZE][j/SQSIZE] = float(wCnt)/78.0;
        }
      }
    }
    return cSize;
  }
}
