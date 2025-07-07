import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../gts_emissao_controller.dart';

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
  final _descricaoController = TextEditingController();
  final _unidadeMedidaController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _pesoController = TextEditingController();
  final _loteController = TextEditingController();

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
                  controller: _descricaoController,
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
                  controller: _unidadeMedidaController,
                  decoration: const InputDecoration(
                    labelText: 'Unidade de medida',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _quantidadeController,
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
                  controller: _pesoController,
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
                  controller: _loteController,
                  decoration: const InputDecoration(
                    labelText: 'Lote',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                const SizedBox(height: 32),

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
                        if (_formKey.currentState!.validate()) {
                          final controller = Modular.get<GtsEmissaoController>();

                          controller.gtsFormData[controller.currentGtsIndex].addAll({
                            'descricao':_descricaoController.text,
                            'unidadeMedida': _unidadeMedidaController.text,
                            'quantidade': _quantidadeController.text,
                            'peso': _pesoController.text,
                            'lote': _loteController.text,
                          });

                          print('Dados salvos no gtsFormData:');
                          print(controller.gtsFormData[controller.currentGtsIndex]);

                          controller.markStepAsCompleted(3); // marca step como concluído
                          widget.onFinishPressed?.call();
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

