class Globals {
  static DateTime? lastRun = DateTime.now().subtract(Duration(seconds: 60));
  static getLastRun() {
    return lastRun;
  }

  static changeLastRun(DateTime a) {
    lastRun = a;
  }
}
