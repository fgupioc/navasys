class User {
  final int id;
  final String document;
  final String type;
  final String firstName;
  final String lastName;

  User({
    required this.id,
    required this.document,
    required this.type,
    required this.firstName,
    required this.lastName,
  });

  String get fullName => '$firstName $lastName';
}
