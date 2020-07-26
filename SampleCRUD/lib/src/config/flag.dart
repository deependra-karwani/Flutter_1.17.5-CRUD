bool _loading = false;

class Flags {
  static setLoading(bool loading) {
    _loading = loading;
  }

  static bool getLoading() {
    return _loading;
  }
}