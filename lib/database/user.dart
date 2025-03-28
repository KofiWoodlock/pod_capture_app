// User model class to represent user data in the application
// Defines the structure of a user with id, email, password hash, and creation time
class User {
  // Optional id (nullable) for database operations allows autoincrement 
  final int? id;
  // Required email for user identification
  final String email;
  // Hashed password for security
  final String passwordHash;
  // Timestamp of user creation
  final String createdAt;

  // Constructor with named parameters, making email, password, and creation time required
  User({
    this.id,
    required this.email,
    required this.passwordHash,
    required this.createdAt
  });

  // Convert User object to a Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'passwordHash': passwordHash,
      'createdAt': createdAt
    };
  }

  // Factory constructor to create a User object from a Map (typically from database query)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      passwordHash: map['passwordHash'],
      createdAt: map['createdAt'],
    );
  }
}

