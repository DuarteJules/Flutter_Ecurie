class Event{
  late String theme;
  late String photo;
  late DateTime date;
  late String description;
  late Object participants;
  late String title;
  late bool status;

  Event(this.theme, this.photo, this.date, this.description, this.participants,
      this.title, this.status);
}