// To parse this JSON data, do
//
//     final feedbacklistmodel = feedbacklistmodelFromJson(jsonString);

import 'dart:convert';

Feedbacklistmodel feedbacklistmodelFromJson(String str) =>
    Feedbacklistmodel.fromJson(json.decode(str));

String feedbacklistmodelToJson(Feedbacklistmodel data) =>
    json.encode(data.toJson());

class Feedbacklistmodel {
  String status;
  List<FeedBackList> list;
  String code;
  String message;

  Feedbacklistmodel({
    required this.status,
    required this.list,
    required this.code,
    required this.message,
  });

  factory Feedbacklistmodel.fromJson(Map<String, dynamic> json) =>
      Feedbacklistmodel(
        status: json["status"],
        list: List<FeedBackList>.from(
            json["list"].map((x) => FeedBackList.fromJson(x))),
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
        "code": code,
        "message": message,
      };
}

class FeedBackList {
  int id;
  String clientfeedback;
  String? adminreplyfeedback;
  int status;
  int active;
  int createdBy;
  DateTime createdDate;
  int updatedBy;
  dynamic updatedDate;

  FeedBackList({
    required this.id,
    required this.clientfeedback,
    required this.adminreplyfeedback,
    required this.status,
    required this.active,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  factory FeedBackList.fromJson(Map<String, dynamic> json) => FeedBackList(
        id: json["id"],
        clientfeedback: json["clientfeedback"],
        adminreplyfeedback: json["adminreplyfeedback"],
        status: json["status"],
        active: json["active"],
        createdBy: json["created_by"],
        createdDate: DateTime.parse(json["created_date"]),
        updatedBy: json["updated_by"],
        updatedDate: json["updated_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "clientfeedback": clientfeedback,
        "adminreplyfeedback": adminreplyfeedback,
        "status": status,
        "active": active,
        "created_by": createdBy,
        "created_date": createdDate.toIso8601String(),
        "updated_by": updatedBy,
        "updated_date": updatedDate,
      };
}
