import 'dart:ffi';

extension Delimiters on double {
  String pointDelimiters() {
    String result = "";
    if (this / 1000000000 >= 1) {
      result = this.toStringAsFixed(1);
      return result.substring(0, result.length - 11) + "B";
    }

    if (this / 1000000 >= 1) {
      result = this.toStringAsFixed(1);
      return result.substring(0, result.length - 8) + "M";
    }

    if (this / 1000 >= 1) {
      result = this.toStringAsFixed(1);
      return result.substring(0, result.length - 5) + "K";
    }
    return this.toStringAsFixed(1);
  }
}

extension ParseDate on String {
  String parseDate() {
    String year = this.substring(2, 4);
    String month = this.substring(5, 7);

    return year + "/" + month;
  }
}