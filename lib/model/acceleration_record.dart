
class AccelerationRecord {
  final int? id;
  final double initialVelocity;
  final double finalVelocity;
  final double time;
  final double acceleration;
  final DateTime createdAt;

  AccelerationRecord({
    this.id,
    required this.initialVelocity,
    required this.finalVelocity,
    required this.time,
    required this.acceleration,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'initial_velocity': initialVelocity,
      'final_velocity': finalVelocity,
      'time': time,
      'acceleration': acceleration,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory AccelerationRecord.fromMap(Map<String, dynamic> map) {
    return AccelerationRecord(
      id: map['id'],
      initialVelocity: map['initial_velocity'],
      finalVelocity: map['final_velocity'],
      time: map['time'],
      acceleration: map['acceleration'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}