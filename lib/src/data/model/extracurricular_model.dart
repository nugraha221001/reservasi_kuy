class ExtracurricularModel {
  ExtracurricularModel({
    this.id,
    this.image,
    this.name,
    this.description,
    this.schedule,
    this.agency,
  });

  ExtracurricularModel.fromJson(dynamic json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    schedule = json['schedule'];
    agency = json['agency'];
  }

  String? id;
  String? image;
  String? name;
  String? description;
  String? schedule;
  String? agency;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['image'] = image;
    map['name'] = name;
    map['description'] = description;
    map['schedule'] = schedule;
    map['agency'] = agency;
    return map;
  }
}
