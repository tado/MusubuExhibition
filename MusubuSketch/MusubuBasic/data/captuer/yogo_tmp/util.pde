String HttpsToHttp(String url){
  String header = "http";
  String body = url.substring(5);
  return header+body;
}