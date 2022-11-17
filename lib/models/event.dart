class Event{
  late String theme;
  late String photo;
  late String date;
  late String description;
  late List<String> participants;
  late String title;
  late bool status;

  Event(this.theme, this.photo, this.date, this.description, this.participants,
      this.title, this.status);

  fromJson(Map<String, dynamic> json){
    return Event(json['theme'], json['photo'], json['date'], json["description"] , List<String>.from(json['participants'] as List), json['title'], json['status'] );
  }
}