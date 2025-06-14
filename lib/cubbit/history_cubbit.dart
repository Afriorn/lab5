// lib/cubits/history_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lab5/model/acceleration_record.dart';
import 'package:lab5/model/database_help.dart';


class HistoryCubit extends Cubit<HistoryState> {
  final DatabaseHelper databaseHelper;

  HistoryCubit({required this.databaseHelper}) : super(HistoryInitial());

  Future<void> loadHistory() async {
    emit(HistoryLoading());
    try {
      final records = await databaseHelper.getAllRecords();
      emit(HistoryLoaded(records));
    } catch (e) {
      emit(HistoryError("Не удалось загрузить историю"));
    }
  }

  Future<void> deleteRecord(int id) async {
    try {
      await databaseHelper.deleteRecord(id);
      final currentState = state;
      if (currentState is HistoryLoaded) {
        final newRecords = currentState.records.where((r) => r.id != id).toList();
        emit(HistoryLoaded(newRecords));
      }
    } catch (e) {
      emit(HistoryError("Не удалось удалить запись"));
    }
  }
}

abstract class HistoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<AccelerationRecord> records;
  
  HistoryLoaded(this.records);

  @override
  List<Object> get props => [records];
}

class HistoryError extends HistoryState {
  final String message;
  
  HistoryError(this.message);

  @override
  List<Object> get props => [message];
}