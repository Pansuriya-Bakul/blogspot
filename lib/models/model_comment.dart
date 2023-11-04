class CommentModel {
  String? cid;
  String? postid;
  String? uid;
  String? uname;
  String? cdtls;
  String? cdate;

  CommentModel({this.cid, this.postid, this.uid, this.uname, this.cdtls});

  CommentModel.fromJson(Map<String, dynamic> json) {
    cid = json['cid'];
    postid = json['postid'];
    uid = json['uid'];
    uname = json['uname'];
    cdtls = json['cdtls'];
    cdate = json['cdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cid'] = this.cid;
    data['postid'] = this.postid;
    data['uid'] = this.uid;
    data['uname'] = this.uname;
    data['cdtls'] = this.cdtls;
    data['cdate'] = this.cdate;
    return data;
  }
}
