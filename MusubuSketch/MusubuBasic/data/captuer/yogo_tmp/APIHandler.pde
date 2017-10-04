class APIHandler {
  final String imgServer = "http://pixabay.com/api/";
  final String APIKey = "5940765-473ab300ba0823791f930fc29";
  final String baseURL = imgServer + "/?key=" + APIKey;
  Dipictor dipictor;
  final int PAGES = 3;
  
  APIHandler(Dipictor _dipictor){
    dipictor = _dipictor;
  }
  
  void load(String imgURL, boolean isTarget) {
    if (isTarget) {
      PImage target = loadImage(imgURL);
      dipictor.setTarget(target);
      dipictor.createPartials();
    }
    ImageLoader imgLoader = new ImageLoader(imgURL, dipictor);
    imgLoader.start();
  }
  ArrayList search(String searchParam) {
    ArrayList<String> searchResult = new ArrayList<String>();
    println("searching");
    for (int i = 1; i < PAGES + 1; i++) {
      String page = str(i);
      String url = searchParam+"&page="+page;
      String res = this.sendRequest(url);
      JSONArray hits = this.extractHits(res);
      for (int j = 0; j < hits.size(); j++) {
        JSONObject imgInstance = hits.getJSONObject(j);
        String imgURL = HttpsToHttp(imgInstance.getString("webformatURL"));
        searchResult.add(imgURL);
      }
    }
    //println("Done Searching", searchResult);
    return searchResult;
  }
  String sendRequest(String searchParam) {
    String url = baseURL + searchParam;
    GetRequest req = new GetRequest(url);
    req.send();
    String res = req.getContent();
    return res;
  }
  JSONArray extractHits(String res) {
    println(res);
    JSONObject json =  parseJSONObject(res);
    int totalHits = json.getInt("totalHits");
    //println("total hit: ", totalHits);
    JSONArray hits = json.getJSONArray("hits");
    return hits;
  }
}