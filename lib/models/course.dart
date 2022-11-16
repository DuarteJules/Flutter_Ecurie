class Course{
  late String title;
  late String description;
  late DateTime date;
  late int duration;
  late String discipline;
  late String place;
  late bool status;
  late String teacher;
  late Object participants;

  Course(this.title, this.description, this.date, this.duration,
      this.discipline, this.place, this.status);
}