class LikeModel {
  String? likeid;
  String? postid;
  String? uid;
  String? uname;
  String? ltype;

  LikeModel({this.likeid, this.postid, this.uid, this.uname, this.ltype});

  LikeModel.fromJson(Map<String, dynamic> json) {
    likeid = json['Likeid'];
    postid = json['postid'];
    uid = json['uid'];
    uname = json['uname'];
    ltype = json['Ltype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Likeid'] = this.likeid;
    data['postid'] = this.postid;
    data['uid'] = this.uid;
    data['uname'] = this.uname;
    data['Ltype'] = this.ltype;
    return data;
  }
}
