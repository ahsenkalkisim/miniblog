//jsonı dart sınıfına modelle => verilerin türleri belirlenmiş olur.(2.aşama)
//API deki verileri dartta kullanmak için modelliyoruz
class Blog {
  String? id;
  String? title;
  String? content;
  String? thumbnail;
  String? author;

  Blog({this.id, this.title, this.content, this.thumbnail, this.author});

  Blog.fromJson(Map<String, dynamic> json) {
    //jsondan classa verileri çekmek
    id = json['id'];
    title = json['title'];
    content = json['content'];
    thumbnail = json['thumbnail'];
    author = json['author'];
  }

  Map<String, dynamic> toJson() {
    //verileri apı ye aktarmak icin
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['thumbnail'] = this.thumbnail;
    data['author'] = this.author;
    return data;
  }
}
