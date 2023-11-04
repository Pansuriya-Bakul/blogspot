class PostModel {
  String? uname;
  String? pid;
  String? pdate;
  String? postCategory;
  String? uid;
  String? ptitle;
  String? pdetails;
  String? pimage;
  String? latitude;
  String? longitude;

  PostModel(
      {this.uname,
      this.pid,
      this.pdate,
      this.postCategory,
      this.uid,
      this.ptitle,
      this.pdetails,
      this.pimage,
      this.latitude,
      this.longitude});

  PostModel.fromJson(Map<String, dynamic> json) {
    uname = json['uname'];
    pid = json['pid'];
    pdate = json['pdate'];
    postCategory = json['post_category'];
    uid = json['uid'];
    ptitle = json['ptitle'];
    pdetails = json['pdetails'];
    pimage = json['pimage'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uname'] = this.uname;
    data['pid'] = this.pid;
    data['pdate'] = this.pdate;
    data['post_category'] = this.postCategory;
    data['uid'] = this.uid;
    data['ptitle'] = this.ptitle;
    data['pdetails'] = this.pdetails;
    data['pimage'] = this.pimage;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    return data;
  }
}
