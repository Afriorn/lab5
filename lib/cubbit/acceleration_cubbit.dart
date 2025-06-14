
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lab5/model/acceleration_record.dart';
import 'package:lab5/model/database_help.dart';


class AccelerationCubit extends Cubit<AccelerationState> {
  final DatabaseHelper databaseHelper;

  AccelerationCubit({required this.databaseHelper}) 
      : super(AccelerationInitial());

  Future<void> calculateAcceleration({
    required double initialVelocity,
    required double finalVelocity,
    required double time,
  }) async {
    if (time == 0) {
      emit(AccelerationError("Время не может быть нулевым"));
      return;
    }

    final acceleration = (finalVelocity - initialVelocity) / time;
    
    final record = AccelerationRecord(
      initialVelocity: initialVelocity,
      finalVelocity: finalVelocity,
      time: time,
      acceleration: acceleration,
      createdAt: DateTime.now(),
    );

    try {
      await databaseHelper.insertRecord(record);
      emit(AccelerationCalculated(acceleration));
    } catch (e) {
      emit(AccelerationError("Ошибка сохранения данных"));
    }
  }

  void reset() {
    emit(AccelerationInitial());
  }
}

abstract class AccelerationState extends Equatable {
  @override
  List<Object> get props => [];
}

class AccelerationInitial extends AccelerationState {}

class AccelerationCalculated extends AccelerationState {
  final double acceleration;
  
  AccelerationCalculated(this.acceleration);

  @override
  List<Object> get props => [acceleration];
}

class AccelerationError extends AccelerationState {
  final String message;
  
  AccelerationError(this.message);

  @override
  List<Object> get props => [message];
}