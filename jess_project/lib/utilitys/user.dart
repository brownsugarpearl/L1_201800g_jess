class Profile {
  String uid;
  String email;
  String name;
  int phone;
  String pic;

  Profile({this.uid, this.email, this.name, this.phone, this.pic});

  Profile.fromMap(Map<String, dynamic> data) {
    uid = data['uid'];
    email = data['email'];
    name = data['name'];
    phone = data['phone'];
    pic = data['pic'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'pic': pic,
    };
  }

  static List<Profile> filterList(List<Profile> vl, String filterString) {
    List<Profile> v = vl
        .where((u) => (u.email
            .toString()
            .toLowerCase()
            .contains(filterString.toLowerCase())))
        .toList();
    return v;
  }
}
