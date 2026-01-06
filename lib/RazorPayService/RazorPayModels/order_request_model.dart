class OrderRequestModel {
  static Map<String, dynamic> getOrderRequestBody(double amount) {
    return {
      "amount": amount,
      "currency": "INR",
      "receipt": "Receipt no. 1",
      "notes": {
        "notes_key_1": "Tea, Earl Grey, Hot",
        "notes_key_2": "Tea, Earl Grey… decaf."
      }
    };
  }
}