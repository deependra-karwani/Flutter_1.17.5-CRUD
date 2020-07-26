class Regs {
  static final nameRE = new RegExp(r"^\w[\w\s]{1,}$");
  static final emailRE = new RegExp(r"^\w.+@\w+\.\w{2,5}$");
  static final mobileRE = new RegExp(r"^([6-9]\d{9})?$");
  static final usernameRE = new RegExp(r"^\w{3,}$");
  static final passwordRE = new RegExp(r"^.{4,}$");
}