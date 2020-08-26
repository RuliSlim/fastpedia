class Video {
  int id;
  String video;

  Video({this.id, this.video});

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      video: json['video']
    );
  }
}

class DataVideo {
  int jatah_nonton;
  int sudah_ditonton;
  int sisa_nonton;
  int sisa_video_di_bank;
  Video data;

  DataVideo({this.data, this.jatah_nonton, this.sisa_nonton, this.sisa_video_di_bank, this.sudah_ditonton});

  factory DataVideo.fromJson(Map<String, dynamic> json) {
    return DataVideo(
      data: Video.fromJson(json["data"]),
      jatah_nonton: json["jatah_nonton"],
      sisa_nonton: json["sisa_nonton"],
      sisa_video_di_bank: json["sisa_video_di_bank"],
      sudah_ditonton: json["sudah_ditonton"]
    );
  }
}