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

class HistoryKeluar {
  int id;
  int sender;
  double nominal;
  String receiver_name;
  String created_at;
  String tipe;
  String receiver_username;
  String sender_username;

  HistoryKeluar({this.id, this.tipe, this.nominal, this.created_at, this.receiver_name, this.receiver_username, this.sender, this.sender_username});

  factory HistoryKeluar.fromJson(Map<String, dynamic> json) {
    return HistoryKeluar(
      id: json['id'],
      tipe: json['tipe'],
      nominal: json['nominal'],
      created_at: json['created'],
      receiver_name: json['receiver_name'],
      receiver_username: json['receiver_username'],
      sender: json['sender'],
      sender_username: json['sender_username']
    );
  }
}

class HistoryUser {
  List<HistoryPoint> data_poin;
  List<HistoryVideo> data_video;
  List<HistoryKeluar> data_keluar;
  List<HistoryKeluar> data_masuk;

  HistoryUser({this.data_poin, this.data_video, this.data_masuk, this.data_keluar});

  factory HistoryUser.fromJson(Map<String, dynamic> json) {
    var listVideo = json['data_video'] as List;
    List<HistoryVideo> historyVideo = listVideo.map((i) => HistoryVideo.fromJson(i)).toList();

    var listPoint = json['data_poin'] as List;
    List<HistoryPoint> historyPoin = listPoint.map((i) => HistoryPoint.fromJson(i)).toList();

    var listKeluar = json['transaksi_keluar'] as List;
    List<HistoryKeluar> historyKeluar = listKeluar.map((i) => HistoryKeluar.fromJson(i)).toList();

    var listMasuk = json['transaksi_masuk'] as List;
    List<HistoryKeluar> historyMasuk = listMasuk.map((i) => HistoryKeluar.fromJson(i)).toList();

    return HistoryUser(
      data_video: historyVideo,
      data_poin: historyPoin,
      data_keluar: historyKeluar,
      data_masuk: historyMasuk
    );
  }
}