class Points {
  double peds;
  double evoucher;
  double ads_point;

  Points({this.peds, this.evoucher, this.ads_point});

  factory Points.fromJson(Map<String, dynamic> json) {
    return Points(
      peds: json['peds'],
      evoucher: json['evoucher'],
      ads_point: json['ads_point']
    );
  }
}