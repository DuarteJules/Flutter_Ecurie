class Horse{
  late String name;
  late String photo;
  late String robe;
  late int age;
  late String race;
  late String sex;
  late String specialty;
  late String owner;
  late Object dp;

  Horse(this.name, this.photo, this.robe, this.age, this.race, this.sex,
      this.specialty, this.owner, this.dp);

  fromJson(Map<String, dynamic> json){
    return Horse(json['name'], json['photo'], json['robe'], int.parse(json['age']) , json['race'], json['sex'], json['specialty'], json['owner'], json['dp']);
  }
}