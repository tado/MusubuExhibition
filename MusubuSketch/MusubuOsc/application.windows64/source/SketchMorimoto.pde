public class SketchMorimoto extends AppBase {

  int Range = 100;//変化の段階数
  int N = 10;//個数
  Circle[] circle;

  public SketchMorimoto(PApplet parentApplet) {
    super(parentApplet);
  }

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    frameRate(30);
    circle = new Circle [ N ];//Circleオブジェクトの箱をN個作る
    for (int i = 0; i < N; i++)
    { //以下は初めのサークルの設定
      float x = random(width);
      float y = random(height);
      float rad = random(width) / 2;
      float colr = random(10, 75);
      float colg = random(10.40);
      float colb = random(10, 60);
      int count = (int)random(Range);//スタートをそれぞれ変える
      circle[i] = new Circle(x, y, rad, colr, colg, colb, count, Range);//それぞれのCircleオブジェクトを作る
    }
  }

  @Override void draw() {
    background(0);
    for (int i = 0; i < N; i++)
      circle[i].paint(); //メソッドを呼び出す
  }
}

public class  Circle //クラスの宣言
{
  //フィールド
  float x;//位置
  float y;
  float rad; //半径
  int count;//カウンター
  int range;//変化の速度
  float colr;//カラー
  float colg;
  float colb;

  Circle(float _x, float _y, float _rad, float _colr, float _colg, float _colb, int _count, int _range)//コンストラクタ
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
  void paint()//メソッド
  {
    int col;
    if (count >= range)//明るさが最大値を超えたら暗くしていく
      col = range * 2 - count;
    else
      col = count;

    noFill();
    strokeWeight(4);
    stroke(colr * col, colg * col, colb * col);
    ellipse(x, y, rad, rad);//(X,Y)の位置に描く
    if (count > range * 2)
    {
      count = 0;//元に戻す
      //新しい円の位置と半径を決める
      x = random(width);
      y = random(height);
      rad = random(width) / 2;
      colr = random(1);
      colg = random(1);
      colb = random(1);
    }
    count++;//カウンターを増やす
  }
}; //Circleクラスの宣言の終わり