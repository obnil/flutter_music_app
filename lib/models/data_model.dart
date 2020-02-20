class Data {
  String type;
  String link;
  int songid;
  String title;
  String author;
  String lrc;
  String url;
  String pic;

	Data.fromJsonMap(Map<String, dynamic> map):
		type = map["type"],
		link = map["link"],
		songid = map["songid"],
    title = map["title"],
    author = map["author"],
    lrc = map["lrc"],
    url = map["url"],
    pic = map["pic"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['type'] = type;
		data['link'] = link;
		data['songid'] = songid;
    data['title'] = title;
    data['author'] = author;
    data['lrc'] = lrc;
    data['url'] = url;
    data['pic'] = pic;
		return data;
	}
}