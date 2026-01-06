class RealTransitionModel {
  String? usersId;
  String? transitionId;
  String? creditId;
  String? debitId;
  String? remarkItem;
  String? loanedMoney;
  String? receivedMoney;
  String? currentDate;
  String? currentTime;
  String? isReceived;
  String? yourCollection;
  String? finalCollection;

  RealTransitionModel({
    this.usersId,
    this.transitionId,
    this.creditId,
    this.debitId,
    this.remarkItem,
    this.loanedMoney,
    this.receivedMoney,
    this.currentDate,
    this.currentTime,
    this.isReceived,
    this.yourCollection,
    this.finalCollection,
  });

  Map<String, dynamic> toMap() {
    return {
      "usersId": usersId,
      "transitionId": transitionId,
      "creditId": creditId,
      "debitId": debitId,
      "remarkItem": remarkItem,
      "loanedMoney": loanedMoney,
      "receivedMoney": receivedMoney,
      "currentDate": currentDate,
      "currentTime": currentTime,
      "isReceived": isReceived,
      "yourCollection": yourCollection,
      "finalCollection":finalCollection,
    };
  }

  factory RealTransitionModel.fromMap(Map<String, dynamic> map) {
    return RealTransitionModel(
      usersId: map["usersId"],
      transitionId: map["transitionId"],
      creditId: map["creditId"],
      debitId: map["debitId"],
      remarkItem: map["remarkItem"],
      loanedMoney: map["loanedMoney"],
      receivedMoney: map["receivedMoney"],
      currentDate: map["currentDate"],
      currentTime: map["currentTime"],
      isReceived: map["isReceived"],
      yourCollection: map["yourCollection"],
      finalCollection: map["finalCollection"],
    );
  }
}
