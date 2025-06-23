

class User {
  int? userid;
  String? username;
  String? email;
  String? usertype;
  int? testid;
  String? name;
  String? contact;
  String? image;
  String? token;
  int? cusid;

  User({
    this.userid,
    this.username,
    this.email,
    this.usertype,
    this.testid,
    this.name,
    this.contact,
    this.image,
    this.token,
    this.cusid
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
        userid: json['user']['id'],
        email: json['user']['Email'],
        username: json['user']['username'],
        usertype: json['user']['usertype'],
        testid: json['shopid'],
        token: json['token'],
        cusid: json['cusId']
    );
  }
}