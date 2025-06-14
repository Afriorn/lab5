// lib/screens/history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lab5/cubbit/history_cubbit.dart';
import 'package:lab5/model/acceleration_record.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

@override
State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Загружаем историю при инициализации экрана
    context.read<HistoryCubit>().loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('История расчетов'),
      ),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is HistoryInitial || state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HistoryError) {
            return Center(child: Text(state.message));
          } else if (state is HistoryLoaded) {
            return _buildHistoryList(state.records, context);
          } else {
            return const Center(child: Text('Неизвестное состояние'));
          }
        },
      ),
    );
  }

  Widget _buildHistoryList(List<AccelerationRecord> records, BuildContext context) {
    if (records.isEmpty) {
      return const Center(child: Text('Нет сохраненных расчетов'));
    }

    return ListView.builder(
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        return Dismissible(
          key: Key(record.id.toString()),
          background: Container(color: Colors.red),
          onDismissed: (direction) {
            context.read<HistoryCubit>().deleteRecord(record.id!);
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ListTile(
              title: Text(
                'Ускорение: ${record.acceleration.toStringAsFixed(2)} м/с²',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Начальная скорость: ${record.initialVelocity} м/с'),
                  Text('Конечная скорость: ${record.finalVelocity} м/с'),
                  Text('Время: ${record.time} с'),
                  Text(
                    DateFormat('dd.MM.yyyy HH:mm').format(record.createdAt),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}