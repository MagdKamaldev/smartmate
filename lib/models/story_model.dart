class StoryModel {
  String? name;
  String? uId;
  String? image;
  String? dateTime;
  String? text;
  String? storyImage;

  StoryModel({
    this.name,
    this.uId,
    this.image,
    this.dateTime,
    this.storyImage,
    this.text,
  });

  StoryModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    image = json["image"];
    uId = json["uId"];
    dateTime = json["dateTime"];
    text = json["text"];
    storyImage = json["storyImage"];
  }
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "uId": uId,
      "image": image,
      "text":text,
      "dateTime":dateTime,
      "storyImage":storyImage,
    };
  }
}
