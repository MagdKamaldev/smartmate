class MessegeModel {
  String? senderId;
  String? recieverId;
  String? dateTime;
  String? text;

  MessegeModel({
    this.senderId,
    this.recieverId,
    this.dateTime,
    this.text,
  });

  MessegeModel.fromJson(Map<String, dynamic> json) {
    senderId = json["senderId"];
    recieverId = json["recieverId"];
    dateTime = json["dateTime"];
    text = json["text"];
  }
  Map<String, dynamic> toMap() {
    return {
      "senderId": senderId,
      "recieverId": recieverId,
      "dateTime": dateTime,
      "text": text,
    };
  }
}
