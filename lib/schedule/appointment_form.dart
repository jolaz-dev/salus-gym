import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salus_gym/schedule/appointment.dart';
import 'package:uuid/uuid.dart';

class AppointmentForm extends StatefulWidget {
  final Appointment appointment;
  final Future<void> Function(Appointment appointment) onSubmit;

  const AppointmentForm({
    super.key,
    required this.appointment,
    required this.onSubmit,
  });

  @override
  State<AppointmentForm> createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late DateTime _selectedDate;
  late TimeOfDay _startTime;
  late TextEditingController _durationController;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();

    final initial = widget.appointment;
    _titleController = TextEditingController(text: initial.title);
    _selectedDate = initial.startTimeLocal;
    _startTime = TimeOfDay.fromDateTime(initial.startTimeLocal);
    final initialDuration = initial.durationInMinutes;
    _durationController = TextEditingController(
      text: initialDuration.toString(),
    );
    _selectedColor = initial.color;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );

    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;

    final title = _titleController.text.trim();
    final duration = int.parse(_durationController.text.trim());

    final startDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _startTime.hour,
      _startTime.minute,
    );

    final appointment = Appointment(
      id: widget.appointment.id.isEmpty ? Uuid().v4() : widget.appointment.id,
      title: title,
      startTimeUtc: startDateTime.toUtc(),
      durationInMinutes: duration,
      color: _selectedColor,
    );

    widget.onSubmit(appointment);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.appointment.id.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEditing ? 'Editar Compromisso' : 'Novo Compromisso',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator:
                    (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Informe um título'
                            : null,
              ),
              if (isEditing)
                ListTile(
                  title: const Text('Início'),
                  subtitle: Text(
                    DateFormat('dd/MM/yyyy – HH:mm').format(
                      DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                        _selectedDate.day,
                        _startTime.hour,
                        _startTime.minute,
                      ),
                    ),
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _pickDate(context),
                ),
              const SizedBox(height: 8),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.access_time),
                label: Text(_startTime.format(context)),
                onPressed: _pickStartTime,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Duração (minutos)',
                  hintText: 'Ex: 60',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final number = int.tryParse(value ?? '');
                  if (number == null) return 'Informe um número válido';
                  if (number < 10) return 'Duração mínima: 10 min';
                  if (number > 1440) return 'Duração máxima: 1440 min';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Cor:'),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () async {
                      final selectedColor = await showDialog<Color>(
                        context: context,
                        builder:
                            (_) => SimpleDialog(
                              title: const Text('Escolha uma cor'),
                              children: [
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children:
                                      Colors.primaries.map((color) {
                                        return GestureDetector(
                                          onTap:
                                              () =>
                                                  Navigator.pop(context, color),
                                          child: Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: color,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ],
                            ),
                      );
                      if (selectedColor != null) {
                        setState(() {
                          _selectedColor = selectedColor;
                        });
                      }
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: _selectedColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black26),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Salvar'),
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
