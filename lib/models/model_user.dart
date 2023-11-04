class UserModel {
  String? uid;
  String? uname;
  String? age;
  String? contact;
  String? email;
  String? pwd;
  String? isNotify;
  String? uphoto;
  String? token;

  UserModel(
      {this.uid,
      this.uname,
      this.age,
      this.contact,
      this.email,
      this.pwd,
      this.isNotify,
      this.uphoto,
      this.token});

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    uname = json['uname'];
    age = json['age'];
    contact = json['contact'];
    email = json['email'];
    pwd = json['pwd'];
    isNotify = json['Is_Notify'];
    uphoto = json['uphoto'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['uname'] = this.uname;
    data['age'] = this.age;
    data['contact'] = this.contact;
    data['email'] = this.email;
    data['pwd'] = this.pwd;
    data['Is_Notify'] = this.isNotify;
    data['uphoto'] = this.uphoto;
    data['token'] = this.token;
    return data;
  }
}
