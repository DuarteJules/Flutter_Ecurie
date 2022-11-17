class Course{
  late String title;
  late String description;
  late DateTime date;
  late String hour;
  late int duration;
  late String discipline;
  late String place;
  late bool status;
  late String teacher;
  late List participants;
  late DateTime createdAt;

  Course(this.title, this.description, this.date, this.duration,
      this.discipline, this.place, this.status);
}