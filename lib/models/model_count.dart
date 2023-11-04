class CountModel {
  String? postId;
  int? count;
  bool? liked;
  bool? commented;

  CountModel({this.postId, this.count, this.liked, this.commented});

  CountModel.fromJson(Map<String, dynamic> json) {
    postId = json['postid'];
    count = json['count'];
    liked = json['liked'];
    commented = json['commented'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postid'] = this.postId;
    data['count'] = this.count;
    data['liked'] = this.liked;
    data['commented'] = this.commented;
    return data;
  }
}
