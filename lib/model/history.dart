class HistoryVideo {
  int id;
  String watched_at;
  int rating;
  int watcher;
  int video;

  HistoryVideo({this.id, this.watched_at, this.watcher, this.video, this.rating});

  factory HistoryVideo.fromJson(Map<String, dynamic> json) {
    return HistoryVideo(
      id: json['id'],
      watched_at: json['watched_at'],
      rating: json['rating'],
      watcher: json['watcher'],
      video: json['video']
    );
  }
}

class HistoryPoint {
  int id;
  double poin_mining;
  int watched_history;
  String created_at;

  HistoryPoint({this.id, this.poin_mining, this.watched_history, this.created_at});

  factory HistoryPoint.fromJson(Map<String, dynamic> json) {
    return HistoryPoint(
      id: json['id'],
      poin_mining: json['poin_mining'],
      watched_history: json['watched_history'],
      created_at: json['created_at']
    );
  }
}

class HistoryUser {
  List<HistoryPoint> data_poin;
  List<HistoryVideo> data_video;

  HistoryUser({this.data_poin, this.data_video});

  factory HistoryUser.fromJson(Map<String, dynamic> json) {
    var listVideo = json['data_video'] as List;
    List<HistoryVideo> historyVideo = listVideo.map((i) => HistoryVideo.fromJson(i)).toList();
    var listPoint = json['data_poin'] as List;
    List<HistoryPoint> historyPoin = listPoint.map((i) => HistoryPoint.fromJson(i)).toList();

    return HistoryUser(
      data_video: historyVideo,
      data_poin: historyPoin
    );
  }
}