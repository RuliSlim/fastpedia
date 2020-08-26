import 'dart:ffi';

extension Delimiters on double {
  String pointDelimiters() {
    String result = "";
    if (this / 1000000000 >= 0) {
      result = this.toStringAsFixed(1);
      return result.substring(0, result.length - 11) + "B";
    }

    if (this / 1000000 >= 0) {
      result = this.toStringAsFixed(1);
      return result.substring(0, result.length - 8) + "M";
    }

    if (this / 1000 >= 0) {
      result = this.toStringAsFixed(1);
      return result.substring(0, result.length - 5) + "K";
    }
    return '';
  }
}