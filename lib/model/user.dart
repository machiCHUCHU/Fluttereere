// class Customer {
//   int? id;
//   String? name;
//   String? sex;
//   String? add;
//   String? cn;
//   String? email;
//   String? username;
//   String? password;
//   String? user_type;
//
//
//   Customer({
//     this.id,
//     this.name,
//     this.sex,
//     this.add,
//     this.cn,
//     this.email,
//     this.username,
//     this.password,
//     this.user_type
//   });
//
//   factory Customer.fromJson(Map<String, dynamic> json){
//     return Customer(
//         id: json['tbl_customer']['id'],
//         name: json['tbl_customer']['Name'],
//         sex: json['tbl_customer']['Sex'],
//         add: json['tbl_customer']['Address'],
//         cn: json['tbl_customer']['ContactNumber'],
//         email: json['tbl_customer']['Email'],
//         username: json['tbl_user']['UserName'],
//         password: json['tbl_user']['Password'],
//         user_type: json['tbl_user']['UserType']
//     );
//   }
// }

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

  User({
    this.userid,
    this.username,
    this.email,
    this.usertype,
    this.testid,
    this.name,
    this.contact,
    this.image,
    this.token
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
        userid: json['user']['id'],
        email: json['user']['Email'],
        username: json['user']['username'],
        usertype: json['user']['usertype'],
        testid: json['shopid'],
        token: json['token']
    );
  }
}


class Profile {
  String? name;

  Profile({
    this.name,

  });

  factory Profile.fromJson(Map<String, dynamic> json){
    return Profile(
        name: json['profile'][0]['Name'],

    );
  }
}
