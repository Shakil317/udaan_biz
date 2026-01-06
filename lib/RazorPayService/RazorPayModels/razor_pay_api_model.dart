import 'dart:convert';
RazorPayApiModel razorPayApiModelFromJson(String str) => RazorPayApiModel.fromJson(json.decode(str));

String razorPayApiModelToJson(RazorPayApiModel data) => json.encode(data.toJson());

class RazorPayApiModel {
  int? amount;
  int? amountDue;
  int? amountPaid;
  int? attempts;
  int? createdAt;
  String? currency;
  String? entity;
  String? id;
  Notes? notes;
  dynamic offerId;
  String? receipt;
  String? status;

  RazorPayApiModel({
    this.amount,
    this.amountDue,
    this.amountPaid,
    this.attempts,
    this.createdAt,
    this.currency,
    this.entity,
    this.id,
    this.notes,
    this.offerId,
    this.receipt,
    this.status,
  });

  factory RazorPayApiModel.fromJson(Map<String, dynamic> json) => RazorPayApiModel(
    amount: json["amount"],
    amountDue: json["amount_due"],
    amountPaid: json["amount_paid"],
    attempts: json["attempts"],
    createdAt: json["created_at"],
    currency: json["currency"],
    entity: json["entity"],
    id: json["id"],
    notes: json["notes"] == null ? null : Notes.fromJson(json["notes"]),
    offerId: json["offer_id"],
    receipt: json["receipt"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "amount_due": amountDue,
    "amount_paid": amountPaid,
    "attempts": attempts,
    "created_at": createdAt,
    "currency": currency,
    "entity": entity,
    "id": id,
    "notes": notes?.toJson(),
    "offer_id": offerId,
    "receipt": receipt,
    "status": status,
  };
}

class Notes {
  String? notesKey1;
  String? notesKey2;

  Notes({
    this.notesKey1,
    this.notesKey2,
  });

  factory Notes.fromJson(Map<String, dynamic> json) => Notes(
    notesKey1: json["notes_key_1"],
    notesKey2: json["notes_key_2"],
  );

  Map<String, dynamic> toJson() => {
    "notes_key_1": notesKey1,
    "notes_key_2": notesKey2,
  };
}
