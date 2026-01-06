class TransitionModels {
  final dynamic usersId;
  final dynamic transitionId;
  final dynamic creditId;
  final dynamic debitId;
  final String? remarkItem;
  final String? loanedMoney;
  final String? receivedMoney;
  final String? currentDate;
  final String? currentTime;
  final String? isReceived;
  final String? yourCollection;

  TransitionModels({
    this.usersId,
    this.transitionId,
    this.creditId,
    this.debitId,
    required this.remarkItem,
    required this.loanedMoney,
    required this.receivedMoney,
    required this.currentDate,
    required this.currentTime,
    required this.isReceived,
    required this.yourCollection
  });
  factory TransitionModels.fromMap(Map<String, dynamic> map) {
    return TransitionModels(
      usersId: map['usersId'],
      remarkItem: map['remarkItem'],
      transitionId: map['transitionId'],
      creditId: map['creditId'],
      debitId: map['debitId'],
      loanedMoney: map['loanedMoney'],
      receivedMoney: map['receivedMoney'],
      currentDate: map['currentDate'],
      currentTime: map['currentTime'],
      isReceived: map['status'],
      yourCollection: map['yourCollection'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'usersId':usersId,
      'remarkItem': remarkItem,
      'transitionId': transitionId,
      'creditId': creditId,
      'debitId': debitId,
      'loanedMoney': loanedMoney,
      'receivedMoney': receivedMoney,
      'currentDate': currentDate,
      'currentTime': currentTime,
      'yourCollection':yourCollection,
    };
  }
}
