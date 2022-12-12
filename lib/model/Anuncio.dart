class Anuncio {
  int? id;
  String? state;
  String? title;
  String? price;
  String? telephone;
  String? category;
  String? description;
  String? emailUser;

  Anuncio(this.state, this.title, this.price, this.telephone, this.category,
      this.description, this.emailUser);

  Anuncio.fromMap(Map map) {
    this.id = map["id"];
    this.title = map["title"];
    this.description = map["description"];
    this.price = map["price"];
    this.telephone = map["telephone"];
    this.category = map["category"];
    this.state = map["state"];
    this.emailUser = map["emailUser"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "title": this.title,
      "description": this.description,
      "price": this.price,
      "telephone": this.telephone,
      "category": this.category,
      "state": this.state,
      "emailUser": this.emailUser,
    };
    map["id"] ??= this.id;

    return map;
  }
}
