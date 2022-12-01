class User {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;

  User(
      {required this.uid,
      required this.firstName,
      required this.lastName,
      required this.email});

  Map<String, dynamic> toMap() {
    return {'first_name': firstName, 'last_name': lastName, 'email': email};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        uid: map['uid'],
        firstName: map['first_name'],
        lastName: map['last_name'],
        email: map['email']);
  }

  String getFirstName() {
    return firstName;
  }

  String getLastName() {
    return lastName;
  }

  String getEmail() {
    return email;
  }

  String getInitials() {
    return "${firstName[0]}${lastName[0]}";
  }
}
