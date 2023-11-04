class NotificationModel {
  String? nid;
  String? ntitle;
  String? ndetails;
  String? ndate;
  String? token;

  NotificationModel({this.nid, this.ntitle, this.ndetails, this.token});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    nid = json['nid'];
    ntitle = json['ntitle'];
    ndetails = json['ndetails'];
    ndate = json['ndate'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nid'] = this.nid;
    data['ntitle'] = this.ntitle;
    data['ndetails'] = this.ndetails;
    data['ndate'] = this.ndate;
    data['token'] = this.token;
    return data;
  }
}
