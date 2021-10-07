class SignUpData {
  const SignUpData(
      {this.fname,
      this.email,
      this.password,
      this.headline,
      this.p1,
      this.p2,
      this.p3});

  final String? fname;
  final String? email;
  final String? password;
  final String? headline;
  final String? p1;
  final String? p2;
  final String? p3;

  SignUpData copyWith(
      {String? fname,
      String? email,
      String? password,
      String? headline,
      String? p1,
      String? p2,
      String? p3}) {
    return SignUpData(
      fname: fname ?? this.fname,
      email: email ?? this.email,
      password: password ?? this.password,
      headline: headline ?? this.headline,
      p1: p1 ?? this.p1,
      p2: p2 ?? this.p2,
      p3: p3 ?? this.p3,
    );
  }
}
