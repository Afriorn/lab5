// lib/screens/acceleration_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'history_screen.dart';
import 'package:lab5/cubbit/acceleration_cubbit.dart';

class AccelerationScreen extends StatefulWidget {
  const AccelerationScreen({super.key});

  @override
  State<AccelerationScreen> createState() => _AccelerationScreenState();
}

class _AccelerationScreenState extends State<AccelerationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _initialVelocityController = TextEditingController();
  final _finalVelocityController = TextEditingController();
  final _timeController = TextEditingController();

  @override
  void dispose() {
    _initialVelocityController.dispose();
    _finalVelocityController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Расчет ускорения'),
        leading: IconButton(
          icon: const Icon(Icons.history),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HistoryScreen(),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AccelerationCubit, AccelerationState>(
          listener: (context, state) {
            if (state is AccelerationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _initialVelocityController,
                    decoration: const InputDecoration(
                      labelText: 'Начальная скорость (м/с)',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите начальную скорость';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _finalVelocityController,
                    decoration: const InputDecoration(
                      labelText: 'Конечная скорость (м/с)',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите конечную скорость';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _timeController,
                    decoration: const InputDecoration(
                      labelText: 'Время (с)',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите время';
                      }
                      if (double.tryParse(value) == 0) {
                        return 'Время не может быть нулевым';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AccelerationCubit>().calculateAcceleration(
                              initialVelocity: double.parse(_initialVelocityController.text),
                              finalVelocity: double.parse(_finalVelocityController.text),
                              time: double.parse(_timeController.text),
                            );
                      }
                    },
                    child: const Text('Рассчитать ускорение'),
                  ),
                  const SizedBox(height: 20),
                  if (state is AccelerationCalculated) ...[
                    Text(
                      'Ускорение: ${state.acceleration.toStringAsFixed(2)} м/с²',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AccelerationCubit>().reset();
                        _initialVelocityController.clear();
                        _finalVelocityController.clear();
                        _timeController.clear();
                      },
                      child: const Text('Сбросить'),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}