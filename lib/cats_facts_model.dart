class CatsFactsModel {
  String? fact;
  int? length;

  CatsFactsModel({this.fact, this.length});

  CatsFactsModel.fromJson(Map<String, dynamic> json) {
    fact = json['fact'];
    length = json['length'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fact'] = this.fact;
    data['length'] = this.length;
    return data;
  }
}