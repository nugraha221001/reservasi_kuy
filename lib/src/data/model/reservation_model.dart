class ReservationModel {
  ReservationModel({
    this.id,
    this.buildingName,
    this.dateStart,
    this.dateEnd,
    this.dateCreated,
    this.contactId,
    this.contactName,
    this.contactEmail,
    this.contactPhone,
    this.information,
    this.status,
    this.image,
    this.agency,
  });

  ReservationModel.fromJson(dynamic json) {
    id = json['id'];
    buildingName = json['buildingName'];
    dateStart = json['dateStart'];
    dateEnd = json['dateEnd'];
    dateCreated = json['dateCreated'];
    contactId = json['contactId'];
    contactName = json['contactName'];
    contactEmail = json['contactEmail'];
    contactPhone = json['contactPhone'];
    information = json['information'];
    status = json['status'];
    image = json['image'];
    agency = json['agency'];
  }

  String? id;
  String? buildingName;
  String? dateStart;
  String? dateEnd;
  String? dateCreated;
  String? contactId;
  String? contactName;
  String? contactEmail;
  String? contactPhone;
  String? information;
  String? status;
  String? image;
  String? agency;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['buildingName'] = buildingName;
    map['dateStart'] = dateStart;
    map['dateEnd'] = dateEnd;
    map['dateCreated'] = dateCreated;
    map['contactId'] = contactId;
    map['contactName'] = contactName;
    map['contactEmail'] = contactEmail;
    map['contactPhone'] = contactPhone;
    map['information'] = information;
    map['status'] = status;
    map['image'] = image;
    map['agency'] = agency;
    return map;
  }
}
