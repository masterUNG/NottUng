class PromoteModel {
  String title;
  String productCode;
  String photo;
  Null priceList;
  String detail;
  String stock;
  String id;

  PromoteModel(
      {this.title,
      this.productCode,
      this.photo,
      this.priceList,
      this.detail,
      this.stock,
      this.id});

  PromoteModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    productCode = json['product_code'];
    photo = json['photo'];
    priceList = json['price_list'];
    detail = json['detail'];
    stock = json['stock'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['product_code'] = this.productCode;
    data['photo'] = this.photo;
    data['price_list'] = this.priceList;
    data['detail'] = this.detail;
    data['stock'] = this.stock;
    data['id'] = this.id;
    return data;
  }
}

