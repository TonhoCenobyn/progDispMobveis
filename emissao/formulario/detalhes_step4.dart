import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DetalhesStep4Page extends StatefulWidget {
  // Callbacks para navegação
  final VoidCallback? onFinishPressed; // Callback para finalizar
  final VoidCallback? onPreviousPressed;

  const DetalhesStep4Page({
    super.key,
    this.onFinishPressed,
    this.onPreviousPressed,
  });

  @override
  State<DetalhesStep4Page> createState() => _DetalhesStep4PageState();
}

class _DetalhesStep4PageState extends State<DetalhesStep4Page> {
  TimeOfDay? _selectedTime;
  String? _filePath;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _timeController = TextEditingController();

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Características  ',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Descrição Resumida *',
                    border: OutlineInputBorder(),
                    hintText: 'Informe uma breve descrição',
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'A descrição é obrigatória';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Unidade de medida',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Quantidade',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Peso',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Lote',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                const SizedBox(height: 32), // Espaço antes dos botões

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Botão Voltar
                    ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Voltar'),
                      onPressed: widget.onPreviousPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                    ),

                    ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Finalizar Emissão'),
                      onPressed: () {
                        // Valida o formulário antes de finalizar
                        if (_formKey.currentState!.validate()) {
                          widget.onFinishPressed?.call(); // Chama o callback de finalizar
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Por favor, preencha os campos obrigatórios desta etapa.')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16), // Espaço extra no final
              ],
            ),
          ),
        );
      },
    );
  }
}

