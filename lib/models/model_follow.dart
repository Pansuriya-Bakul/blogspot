class FollowModel {
  String? fid;
  String? personid;
  String? personName;
  String? followerid;
  String? followername;

  FollowModel(
      {this.fid,
      this.personid,
      this.personName,
      this.followerid,
      this.followername});

  FollowModel.fromJson(Map<String, dynamic> json) {
    fid = json['fid'];
    personid = json['personid'];
    personName = json['person_name'];
    followerid = json['followerid'];
    followername = json['followername'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fid'] = this.fid;
    data['personid'] = this.personid;
    data['person_name'] = this.personName;
    data['followerid'] = this.followerid;
    data['followername'] = this.followername;
    return data;
  }
}
