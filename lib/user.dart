class User {
  final int? id; // Making it nullable because the backend might not send it during login
  final String fullName;
  final String username;
  final String email;
  final String password; // You can exclude this for security reasons, but it's included in the example
  final int age;
  final String nationality;
  final String sex;
  final String phoneNumber;
  final String address;
  final String specialty;

  // Constructor to initialize the properties
  User({
    this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.password,
    required this.age,
    required this.nationality,
    required this.sex,
    required this.phoneNumber,
    required this.address,
    required this.specialty,
  });

  // Factory method to create a User from a JSON response
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      username: json['username'],
      email: json['email'],
      password: json['password'], // Ideally, you would not include password in the model
      age: json['age'],
      nationality: json['nationality'],
      sex: json['sex'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      specialty: json['specialty'],
    );
  }

  // Method to convert User object back to JSON (optional)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'username': username,
      'email': email,
      'password': password, // Should ideally not be included in production code
      'age': age,
      'nationality': nationality,
      'sex': sex,
      'phoneNumber': phoneNumber,
      'address': address,
      'specialty': specialty,
    };
  }
}
