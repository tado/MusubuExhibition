import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import oscP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class MusubuOsc extends PApplet {



//SketchIndex index;
ArrayList<AppBase> apps;
int selected;
int prevselect;

//oscP5
OscP5 oscP5;

public void setup() {
  
  //size(1920, 1080);

  //AppList
  apps = new ArrayList<AppBase>();
  apps.add(new SketchFujii(this));
  apps.add(new SketchMatsuda(this));
  apps.add(new SketchSuzuki(this));
  apps.add(new SketchKamiya(this));
  apps.add(new SketchTanaka(this));
  apps.add(new SketchTsukamoto(this));
  apps.add(new SketchMafune(this));
  apps.add(new SketchHanda(this));
  apps.add(new SketchKim(this));
  apps.add(new SketchMorimoto(this));
  apps.add(new SketchYogo(this));

  selected = -1;
  prevselect = selected;
  if (selected > -1) {
    apps.get(selected).setup();
  }

  //OSC
  oscP5 = new OscP5(this, 12000);
}

public void draw() {
  if(selected != prevselect){
    apps.get(selected).setup();
    prevselect = selected;
  }
  if (selected >= 0) {
    apps.get(selected).draw();
    apps.get(selected).mouseX = mouseX;
    apps.get(selected).mouseY = mouseY;
  }
}

public void mouseDragged() {
  if (selected >= 0) {
    apps.get(selected).mouseDragged();
  }
}

public void mousePressed() {
  if (selected >= 0) {
    apps.get(selected).mousePressed();
  }
}

public void mouseMoved() {
}

public void mouseReleased() {
  if (selected >= 0) {
    if (mouseX < 100 && mouseY < 100) {
      selected = -1;
    } else {
      apps.get(selected).mouseReleased();
    }
  }
}

public void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/switch")) {
    selected = msg.get(0).intValue();
    apps.get(selected).setup();
  }
}

/**
 * Here we use key presses to determine which
 * app to display.
 **/
public void keyPressed() {
  background(0);
  if (key == '0') {
    selected = 0;
  }
  if (key == '1') {
    selected = 1;
  }
  if (key == '2') {
    selected = 2;
  }
  if (key == '3') {
    selected = 3;
  }
  if (key == '4') {
    selected = 4;
  }
  if (key == '5') {
    selected = 5;
  }
  if (key == '6') {
    selected = 6;
  }
  if (key == '7') {
    selected = 7;
  }
  if (key == '8') {
    selected = 8;
  }
  if (key == '9') {
    selected = 9;
  }
  if (key == 'a') {
    selected = 10;
  }
  apps.get(selected).setup();
}

public void setSketch(int n) {
  selected = n;
  apps.get(selected).setup();
}
public abstract class AppBase
{
  protected PApplet parent;

  int mouseX;
  int mouseY;

  public AppBase(PApplet parentApplet) {
    this.parent = parentApplet;
  }

  public void setup() {
  }

  public void draw() {
  }

  public void mouseReleased() {
  }

  public void mouseDragged(){
  }

  public void mousePressed() {
  }
}
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
    xUnit = PApplet.parseInt(width / parent.GRID);
    yUnit = PApplet.parseInt(height / parent.GRID);
    images = new ArrayList<ImageContainer>();
    partials = new ArrayList<Partial>();
  }

  public void addImage(ImageContainer img) {
    this.images.add(img);
  }

  public void setTarget(PImage target) {
    this.target = target;
    this.target.resize(width, height);
  }

  public void changeTarget(ImageContainer target) {
    this.setTarget(target.sourceImage);
    this.resetPartials();
  }

  public void resetPartials() {
    this.partials.clear();
    this.createPartials();
  }

  public void updateGRID() {
    this.xUnit = floor(width / parent.GRID);
    this.yUnit = floor(height / parent.GRID);
    this.resetPartials();
    this.resizeImages();
  }
  public void resizeImages(){
    for(int i = 0; i < this.images.size(); i++){
      this.images.get(i).resizeImage();
    }
  }

  public void createPartials() {
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

  public void updatePartials() {
    for (Partial part : partials) {
      ImageContainer material = this.pickFittestImage(part.sourceImage);
      part.setMaterial(material);
    }
  }

  public ImageContainer copyPixels(PImage sourceImage, int x, int y) {
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

  public ImageContainer pickFittestImage(ImageContainer sourceImage) {
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
  public void showPartials() {
    for (Partial part : partials) {
      try {
        part.show();
        //part.showRect();
      }
      catch(NullPointerException e) {
      }
    }
  }

  public void showTarget() {
    image(target, 0, 0);
  }

  public void showGallery() {
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
class ImageContainer {
  public PImage sourceImage;
  public PImage resizedImage;
  public PVector imgVector;
  int GRID = 10;

  ImageContainer(PImage sourceImg) {
    this.sourceImage = sourceImg;
  }

  public void calcColor() {
    this.resizeImage();
    resizedImage.loadPixels();
    int dimension = resizedImage.width * resizedImage.height;
    int sumRed = 0;
    int sumGreen = 0;
    int sumBlue = 0;
    for(int i = 0; i < dimension; i++){
      int c = resizedImage.pixels[i];
      sumRed += red(c);
      sumGreen += green(c);
      sumBlue += blue(c);
    }
    float red = sumRed / dimension;
    float green = sumGreen / dimension;
    float blue = sumBlue / dimension;
    this.imgVector = new PVector(red, green, blue);
  }
  public void resizeImage() {
    this.resizedImage = copyImage(this.sourceImage);
    this.resizedImage.resize(width/GRID, height/GRID);
  }
  public void show(float x, float y) {
    image(this.resizedImage, x, y);
  }
  public void showRect(float x, float y){
    fill(imgVector.x, imgVector.y, imgVector.z);
    rect(x, y, this.resizedImage.width, this.resizedImage.height);
  }
}
class Partial {
  PVector pos;
  public ImageContainer sourceImage;
  ImageContainer materialImage;
  Partial(ImageContainer sourceImage,  PVector pos) {
    this.sourceImage = sourceImage;
    this.pos = pos;
  }
  public void setMaterial(ImageContainer materialImage){
    this.materialImage = materialImage;
  }
  public void show() {
    this.materialImage.show(pos.x, pos.y);
  }
  public void showRect(){
    this.materialImage.showRect(pos.x, pos.y);
  }
}
public class SketchBase extends AppBase {

  PImage img;

  public SketchBase(PApplet parentApplet) {
    super(parentApplet);
  }

  public @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    frameRate(60);
  }

  public @Override void draw() {

  }
}
public class SketchFujii extends AppBase {

  PImage img;

  public SketchFujii(PApplet parentApplet) {
    super(parentApplet);

    img = loadImage("fujii.jpg");
    img.resize(width, height);
  }

  public @Override
    void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    frameRate(60);
    background(0);
    noStroke();
    rectMode(CENTER);
  }

  public @Override
    void draw() {
    for (int i=0; i<100; i++) {
      int x = PApplet.parseInt(random(width));
      int y = PApplet.parseInt(random(height));
      int col =img.get(x, y);
      fill(col, 127);
      pushMatrix();
      translate(x, y);
      rotate(map(hue(col), 0, 255, 0, PI));
      float w = map(saturation(col), 0, 255, 1, 40);
      rect(0, 0, w, 1.5f);
      popMatrix();
    }
  }
}
public class SketchHanda extends AppBase {

  PImage img, img_mask;
  float frame = 0.f;
  float dur = 50.f;
  float x=0.f;
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

  public @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    frameRate(60);
    //img_mask = createImage(1280,720, RGB);

    //image(img_mask, 0, 0, 1280,720);
    boolean flg[][] = edge(img);
    cSize_pub = pixelate(flg);
    fill(255, 255, 255);
    //draw(flg, cSize);
  }

  public @Override void draw() {
    if (frame==0.f&&y==0.f) {
      img = loadImage("handa/image"+str(imgnum%imgqt)+".jpg");
      img.resize(width, height);
      //image(img_mask, 0, 0, 1280,720);
      boolean flg[][] = edge(img);
      cSize_pub = pixelate(flg);
      frame = (sin(-0.5f*PI+PI*x/(dur))+1)*0.5f;
      background(0);
      tint(255.0f, 255.f*(1-frame));
      image(img, 0, 0);
      fill(255, 255, 255);
      x += 1.f;
    } else if (frame<1.f && y==0) {
      background(0);
      tint(255.0f, 255.f*(1-frame));
      image(img, 0, 0);
      drawEdge(cSize_pub);
      frame = (sin(-0.5f*PI+PI*x/(dur))+1)*0.5f;
      x += 1.f;
      //print(str(frame)+"\n");
    } else if (frame>0.98f && y==0.f) {
      imgnum++;
      img = loadImage("handa/image"+str(imgnum%imgqt)+".jpg");
      img.resize(width, height);
      boolean flg[][] = edge(img);
      cSize_pub_lt = pixelate(flg);
      y++;
      //print(str(frame)+"\n");
    } else if (y == 1.f && frame>0.01f) {
      //print("*****************************");
      drawEdgeChng(cSize_pub, cSize_pub_lt);
      frame = (sin(-0.5f*PI+PI*x/(dur))+1)*0.5f;
      //print(frame+"\n");
      x += 1.f;
    } else if (y==1.f && frame <= 0.01f) {
      //print("*****************************");
      drawEdge(cSize_pub_lt);
      y++;
      x += 1.f;
    } else if (y==2.f && 0.98f>frame &&frame>=0.f) {
      frame = (sin(-0.5f*PI+PI*x/(dur))+1)*0.5f;
      background(0);
      tint(255.0f, 255.f*frame);
      image(img, 0, 0);
      drawEdgeBack(cSize_pub_lt);
      x += 1.f;
      //print("kokodayo");
      //print(str(frame)+"\n");
    } else if (y==2.f && frame >0.98f) {
      y=0;
      x=0;
      frame=0;
      //print("kitayo");
      //print(str(frame)+"\n");
    }
  }

  public void drawEdge(float[][] cSize) {
    for (int j = 0; j < height; j += SQSIZE) {
      for (int i = 0; i < width; i += SQSIZE) {
        //img_mask.set(x, j, color(abs(g)*frame + red(col)*(1.0-frame),abs(g)*frame + green(col)*(1.0-frame),abs(g)*frame + blue(col)*(1.0-frame)));
        ellipse(i+SQSIZE/2, j+SQSIZE/2, SQSIZE*cSize[i/SQSIZE][j/SQSIZE]*frame, SQSIZE*cSize[i/SQSIZE][j/SQSIZE]);
      }
    }
  }

  public void drawEdgeBack(float[][] cSize) {
    for (int j = 0; j < height; j += SQSIZE) {
      for (int i = 0; i < width; i += SQSIZE) {
        //img_mask.set(x, y, color(abs(g)*frame + red(col)*(1.0-frame),abs(g)*frame + green(col)*(1.0-frame),abs(g)*frame + blue(col)*(1.0-frame)));
        ellipse(i+SQSIZE/2, j+SQSIZE/2, SQSIZE*cSize[i/SQSIZE][j/SQSIZE]*(1-frame), SQSIZE*cSize[i/SQSIZE][j/SQSIZE]);
      }
    }
  }

  public void drawEdgeChng(float[][] cSize, float[][] cSize_lt) {
    //print(str(frame)+"\n");
    for (int j = 0; j < height; j += SQSIZE) {
      for (int i = 0; i < width; i += SQSIZE) {
        //img_mask.set(x, y, color(abs(g)*frame + red(col)*(1.0-frame),abs(g)*frame + green(col)*(1.0-frame),abs(g)*frame + blue(col)*(1.0-frame)));

        ellipse(i+SQSIZE/2, j+SQSIZE/2, SQSIZE*cSize[i/SQSIZE][j/SQSIZE]*(frame)+SQSIZE*cSize_lt[i/SQSIZE][j/SQSIZE]*(1-frame), SQSIZE*cSize[i/SQSIZE][j/SQSIZE]*(frame)+SQSIZE*cSize_lt[i/SQSIZE][j/SQSIZE]*(1-frame));
      }
    }
  }

  public boolean[][] edge(PImage input) {
    float gvs;
    float ghs;
    float g;
    int col;
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

  public float[][] pixelate(boolean[][] flg) {
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
          cSize[i/SQSIZE][j/SQSIZE] = 1.f;
        } else {
          cSize[i/SQSIZE][j/SQSIZE] = PApplet.parseFloat(wCnt)/78.0f;
        }
      }
    }
    return cSize;
  }
}
public class SketchIndex {
  int col = 6;
  int row = 2;
  MusubuOsc parentApplet;
  MenuRectButton menuButton[] = new MenuRectButton[row * col];
  public SketchIndex(MusubuOsc _parentApplet){
    parentApplet = _parentApplet;

    int buttonWidth = width / col;
    int buttonHeight = height / row / 2;
    for(int j = 0; j < row; j++){
      for(int i = 0; i < col; i++){
        menuButton[j * col + i] = new MenuRectButton(parentApplet, buttonWidth * i, height / 2 + buttonHeight * j, buttonWidth, buttonHeight, j * col + i);
      }
    }
  }

  public void draw(){
    background(0);
    colorMode(RGB, 255, 255, 255, 255);
    noTint();
    fill(255);
    text("Main Menu", 20, 20);
    for(int i = 0; i < row*col; i++){
      menuButton[i].draw();
    }
  }

  public void mouseReleased(){
    for(int i = 0; i < row*col; i++){
      menuButton[i].mouseReleased();
    }
  }

  public void mouseMoved(){
    for(int i = 0; i < row*col; i++){
      menuButton[i].mouseMoved();
    }
  }
}

public class MenuRectButton {
  int x, y, rwidth, rheight, index;
  boolean rollOvered;
  MusubuOsc parentApplet;
  public MenuRectButton(MusubuOsc _parentApplet, int _x, int _y, int _width, int _height, int _index){
    x = _x;
    y = _y;
    rwidth = _width;
    rheight = _height;
    index = _index;
    parentApplet = _parentApplet;
    rollOvered = false;
  }

  public void draw(){
    rectMode(CORNER);
    strokeWeight(1);

    if(rollOvered){
      stroke(200);
      fill(127);
    } else {
      stroke(127);
      noFill();
    }
    rect(x, y, rwidth, rheight);
  }

  public void mouseReleased(){
    if(mouseX > x
      && mouseX < x + rwidth
      && mouseY > y
      && mouseY < y + rheight
      ){
        parentApplet.setSketch(index);
      }
  }

  public void mouseMoved(){
    if(mouseX > x
      && mouseX < x + rwidth
      && mouseY > y
      && mouseY < y + rheight
      ){
        rollOvered = true;
      } else {
        rollOvered = false;
      }
  }
}
public class SketchKamiya extends AppBase {

  int NUM = 100; 
  PVector[] location = new PVector[NUM];
  PVector[] velocity = new PVector[NUM];

  public SketchKamiya(PApplet parentApplet) {
    super(parentApplet);
  }

  public @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    frameRate(60);
    float diameter = random(100);
    noStroke(); 
    fill(random(255), random(255), random(255)); 
    ellipse(random(width), random(height), diameter, diameter);
    for (int i = 0; i < NUM; i++) { 
      location[i] = new PVector(random(width), random(height));
      velocity[i] = new PVector(random(10), random(10));
    }
  }

  public @Override void draw() {
    background(150); 
    for (int i = 0; i < NUM; i++) { 
      float diameter = random(375);
      noStroke(); 
      fill(random(1000), random(1000), random(1000)); 
      ellipse(random(width), random(height), diameter, diameter);
      location[i].add(velocity[i]);
      if ((location[i].x > width) || (location[i].x < 0)) {
        velocity[i].x *= -1;
      }
      if ((location[i].y > height) || (location[i].y < 0)) {
        velocity[i].y *= -1;
      }
    }
  }
}
public class SketchKim extends AppBase {

  PImage img;
  int cellsize = 6;
  int cols, rows;
  int x, y;
  int c;
  float sz;
  float noiseOff1 = 4;
  float noiseOff2 = 0;

  public SketchKim(PApplet parentApplet) {
    super(parentApplet);

    img = loadImage("kim.jpg");
    img.resize(width, height);
  }

  public @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    frameRate(20);
    cols = width/cellsize;
    rows = height/cellsize;
  }

  public @Override void draw() {
    background(0);

    img.loadPixels();

    // Begin loop for columns
    for (int i = 0; i < cols; i++ ) {
      for (int j = 0; j < rows; j++ ) {
        int x = i*cellsize + cellsize/2; // x position
        int y = j*cellsize + cellsize/2; // y position
        int loc = x + y * width;         // Pixel array location
        int c = img.pixels[loc];       // Grab the color
        float sz = (saturation(c)/255) * cellsize;

        pushMatrix();
        float n1 = constrain(noise(noiseOff1) + 0.6f, 0, 1);
        float n2 = noise(noiseOff2);
        fill(blue(c) * n1, green(c) * n2, red(c) * n1);
        noStroke();
        ellipseMode(CENTER);
        ellipse(x, y, sz, sz);
        noiseOff1 = noiseOff2 + 0.1f;
        if (noiseOff1 > 50000) {
          noiseOff1 = 4;
        }
        noiseOff2 = noiseOff2 + 0.2f;
        if (noiseOff2 > 50000) {
          noiseOff2 = 0;
        }
        popMatrix();
        //noiseOff1 = 0;
      }
    }
  }
}
public class SketchMafune extends AppBase {

  int num = 10000;
  int frames = 150;
  float theta;
  PImage img;

  public SketchMafune(PApplet parentApplet) {
    super(parentApplet);
    img = loadImage("mafune0.jpg");
  }

  public @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    frameRate(60);
    //tint(150);
    img.filter(BLUR, 1);
  }

  public @Override void draw() {
    tint(150);
    image(img, 0, 0, width, height);
    randomSeed(5000);
    noStroke();

    fill(0);
    ellipse(width/2.0f, height/2.0f, 300, 300);

    translate(width/2.0f, height/2.0f);
    for (int i=0; i<num; i++) {
      pushMatrix();
      float r = random(TWO_PI);
      rotate(r);
      float s = 300/2.0f;
      float d =  random(s-5, height*.50f);
      float x = map(sin(theta+random(TWO_PI)), -1, 1, s, d);
      float sz = random(0.1f, 3);
      fill(255, 100);
      ellipse(x, 0, sz, sz);
      popMatrix();
    }
    theta += TWO_PI/frames;
    //if (frameCount<=frames) saveFrame("image-###.gif");

    noTint();
  }
}
public class SketchMatsuda extends AppBase {

  PImage img;

  public SketchMatsuda(PApplet parentApplet) {
    super(parentApplet);
    img = loadImage("matsuda.jpg");
    img.resize(width, height);
  }

  public @Override
    void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    frameRate(60);
    background(0);
  }

  public @Override
    void draw() {
    for (int i = 0; i < 100; i++) {
      noStroke();
      int x = PApplet.parseInt(random(width));
      int y = PApplet.parseInt(random(height));
      int col = img.get(x, y);
      fill(col);
      rectMode(CENTER);
      pushMatrix();
      rect(x, y, 30, 30);
      popMatrix();
    }
  }
}
public class SketchMorimoto extends AppBase {

  int Range = 100;//\u5909\u5316\u306e\u6bb5\u968e\u6570
  int N = 10;//\u500b\u6570
  Circle[] circle;

  public SketchMorimoto(PApplet parentApplet) {
    super(parentApplet);
  }

  public @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    frameRate(30);
    circle = new Circle [ N ];//Circle\u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u306e\u7bb1\u3092N\u500b\u4f5c\u308b
    for (int i = 0; i < N; i++)
    { //\u4ee5\u4e0b\u306f\u521d\u3081\u306e\u30b5\u30fc\u30af\u30eb\u306e\u8a2d\u5b9a
      float x = random(width);
      float y = random(height);
      float rad = random(width) / 2;
      float colr = random(10, 75);
      float colg = random(10.40f);
      float colb = random(10, 60);
      int count = (int)random(Range);//\u30b9\u30bf\u30fc\u30c8\u3092\u305d\u308c\u305e\u308c\u5909\u3048\u308b
      circle[i] = new Circle(x, y, rad, colr, colg, colb, count, Range);//\u305d\u308c\u305e\u308c\u306eCircle\u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u3092\u4f5c\u308b
    }
  }

  public @Override void draw() {
    background(0);
    for (int i = 0; i < N; i++)
      circle[i].paint(); //\u30e1\u30bd\u30c3\u30c9\u3092\u547c\u3073\u51fa\u3059
  }
}

public class  Circle //\u30af\u30e9\u30b9\u306e\u5ba3\u8a00
{
  //\u30d5\u30a3\u30fc\u30eb\u30c9
  float x;//\u4f4d\u7f6e
  float y;
  float rad; //\u534a\u5f84
  int count;//\u30ab\u30a6\u30f3\u30bf\u30fc
  int range;//\u5909\u5316\u306e\u901f\u5ea6
  float colr;//\u30ab\u30e9\u30fc
  float colg;
  float colb;

  Circle(float _x, float _y, float _rad, float _colr, float _colg, float _colb, int _count, int _range)//\u30b3\u30f3\u30b9\u30c8\u30e9\u30af\u30bf
  {
    x = _x;
    y = _y;
    rad = _rad;
    colr = _colr;
    colg = _colg;
    colb = _colb;
    count = _count;
    range = _range;
  }
  public void paint()//\u30e1\u30bd\u30c3\u30c9
  {
    int col;
    if (count >= range)//\u660e\u308b\u3055\u304c\u6700\u5927\u5024\u3092\u8d85\u3048\u305f\u3089\u6697\u304f\u3057\u3066\u3044\u304f
      col = range * 2 - count;
    else
      col = count;

    noFill();
    strokeWeight(4);
    stroke(colr * col, colg * col, colb * col);
    ellipse(x, y, rad, rad);//(X,Y)\u306e\u4f4d\u7f6e\u306b\u63cf\u304f
    if (count > range * 2)
    {
      count = 0;//\u5143\u306b\u623b\u3059
      //\u65b0\u3057\u3044\u5186\u306e\u4f4d\u7f6e\u3068\u534a\u5f84\u3092\u6c7a\u3081\u308b
      x = random(width);
      y = random(height);
      rad = random(width) / 2;
      colr = random(1);
      colg = random(1);
      colb = random(1);
    }
    count++;//\u30ab\u30a6\u30f3\u30bf\u30fc\u3092\u5897\u3084\u3059
  }
}; //Circle\u30af\u30e9\u30b9\u306e\u5ba3\u8a00\u306e\u7d42\u308f\u308a
public class SketchSuzuki extends AppBase {

  PImage img;

  public SketchSuzuki(PApplet parentApplet) {
    super(parentApplet);
  }

  public @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    frameRate(60);
    rectMode(CENTER);
    background(0);
  }

  public @Override void draw() {
    fill(20, 10);
    rect( width/2, height/2, width, height);
    rect( width/2, height/2, width, height);

    fill(random(200, 255), random(200, 255), random(200, 255));
    ellipse(random(width), random(height), random(5, 10), random(5, 10));
    noStroke();
    rect(width/2, height/2, 100, 200);
  }
}
public class SketchTanaka extends AppBase {

  FloatList locX = new FloatList();
  FloatList locY = new FloatList();

  public SketchTanaka(PApplet parentApplet) {
    super(parentApplet);
    background(0);
  }

  public @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    frameRate(20);
    //FloatList locX = new FloatList();
    //FloatList locY = new FloatList();
    background(0);

    locX.clear();
    locY.clear();
    locX.append(random(200, width-200));
    locY.append(random(200, height-200));
  }

  public @Override void draw() {
    background(0);
    float en = random(1, 10);
    float light = random(240, 255);

    fill(light);
    noStroke();

    //ellipse(mouseX, mouseY, en, en);

    for (int i = 0; i < locX.size(); i++) {
      ellipse(locX.get(i), locY.get(i), en, en);
    }

    stroke(255, 255, 255, 95);
    noFill();

    for (int i = 0; i < locX.size()-1; i++) {
      line(locX.get(i), locY.get(i), locX.get(i+1), locY.get(i+1));
    }

    //auto play mode
    if(frameCount % 30 == 0){
      locX.append(random(200, width-200));
      locY.append(random(200, height-200));
    }
  }

 /*
  @Override void mouseReleased() {
    locX.append(mouseX);
    locY.append(mouseY);
  }
  */
}
public class SketchTsukamoto extends AppBase {

  int barWidth = 20;
  int lastBar = -1;

  public SketchTsukamoto(PApplet parentApplet) {
    super(parentApplet);
  }

  public @Override void setup() {
    frameRate(60);
    colorMode(HSB, width, height, 100);
    noStroke();
    rectMode(CORNER);
    background(0);
  }

  public @Override void draw() {
    //autoplay mode
    int whichBar = PApplet.parseInt(sin(frameCount/20.0f) * width/2 + width/2) / barWidth;
    //int whichBar = mouseX / barWidth;
    if (whichBar != lastBar) {
      int barX = whichBar * barWidth;
      //fill(barX, mouseY, 66);
      fill(barX, random(190,255), 66);
      rect(barX, 0, barWidth, height);
      lastBar = whichBar;
    }
  }
}
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

  public @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    frameRate(60);

    targetID = 1;
    GRID = 10;
  }

  boolean shouldShowTarget = false;
  public @Override void draw() {
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

  public void updateGallery() {
    //if (GRID > 150) {
    if (GRID > 80) {
      GRID = 10;
      dipictor.updateGRID();
      switchPhoto();
    } else {
      GRID = floor(GRID * 1.5f);
      dipictor.updateGRID();
    }
  }

  public void switchPhoto() {
    if (targetID < GALLERY_SIZE-2) {
      targetID++;
    } else {
      targetID = 0;
    }
    ImageContainer target = dipictor.images.get(targetID);
    dipictor.changeTarget(target);
  }
  public void keyPressed() {
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
        GRID = floor(GRID * 1.5f);
        dipictor.updateGRID();
      }
    }
    if (keyCode == DOWN) {
      if (GRID > 5) {
        GRID = floor(GRID / 1.5f);
        dipictor.updateGRID();
      }
    }
  }
}
public String HttpsToHttp(String url){
  String header = "http";
  String body = url.substring(5);
  return header+body;
}


public PImage copyImage(PImage original){
  PImage clone = createImage(original.width, original.height, RGB);
  clone.set(0,0,original);
  return clone;
}
  public void settings() {  fullScreen(1); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "MusubuOsc" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
