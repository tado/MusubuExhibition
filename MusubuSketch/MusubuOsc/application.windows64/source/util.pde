String HttpsToHttp(String url){
  String header = "http";
  String body = url.substring(5);
  return header+body;
}


PImage copyImage(PImage original){
  PImage clone = createImage(original.width, original.height, RGB);
  clone.set(0,0,original);
  return clone;
}