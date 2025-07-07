import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../gts_emissao_controller.dart';

class DetalhesStep2Page extends StatefulWidget {
  // Callbacks para navegação
  final VoidCallback? onNextPressed;
  final VoidCallback? onPreviousPressed;

  const DetalhesStep2Page({
    super.key,
    this.onNextPressed,
    this.onPreviousPressed,
  });

  @override
  State<DetalhesStep2Page> createState() => _DetalhesStep2PageState();
}

class _DetalhesStep2PageState extends State<DetalhesStep2Page> {
  bool _isUrgente = false;
  String? _selectedPrioridade;
  final _nomeFantasiaDestinoController = TextEditingController();
  final _cpfCnpjDestinoController = TextEditingController();
  final _inscricaoEstadualDestinoController = TextEditingController();
  final _cepController = TextEditingController();
  final _logradouroController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();
  final _municipioController = TextEditingController();
  final _ufController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nomeFantasiaDestinoController.dispose();
    _cpfCnpjDestinoController.dispose();
    _inscricaoEstadualDestinoController.dispose();
    _cepController.dispose();
     _logradouroController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    _municipioController.dispose();
    _ufController.dispose();
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
                  'Estabelecimento de Destino',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nomeFantasiaDestinoController,
                  decoration: const InputDecoration(
                    labelText: 'Nome Fantasia',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _cpfCnpjDestinoController,
                  decoration: const InputDecoration(
                    labelText: 'CPF/CNPJ',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _inscricaoEstadualDestinoController,
                  decoration: const InputDecoration(
                    labelText: 'Inscrição Estadual',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _cepController,
                  decoration: const InputDecoration(
                    labelText: 'CEP',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _logradouroController,
                  decoration: const InputDecoration(
                    labelText: 'Logradouro',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _numeroController,
                  decoration: const InputDecoration(
                    labelText: 'Número',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _complementoController,
                  decoration: const InputDecoration(
                    labelText: 'Complemento',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _municipioController,
                  decoration: const InputDecoration(
                    labelText: 'Município',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _ufController,
                  decoration: const InputDecoration(
                    labelText: 'Estado',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 32), // Espaço antes dos botões

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Voltar'),
                      onPressed: widget.onPreviousPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                    ),

                    if (widget.onNextPressed != null)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Avançar'),
                        onPressed: () {
                          // Valida o formulário antes de avançar
                          if (_formKey.currentState!.validate()) {
                            final controller = Modular.get<GtsEmissaoController>();

                            controller.gtsFormData[controller.currentGtsIndex].addAll({
                              'destinoNomeFantasia': _nomeFantasiaDestinoController.text,
                              'destinoCpfCnpj': _cpfCnpjDestinoController.text,
                              'destinoInscricaoEstadual': _inscricaoEstadualDestinoController.text,
                              'destinoCep': _cepController.text,
                              'destinoLogradouro': _logradouroController.text,
                              'destinoNumero': _numeroController.text,
                              'destinoComplemento': _complementoController.text,
                              'destinoMunicipio': _municipioController.text,
                              'destinoUF': _ufController.text,
                            });

                            print('Dados salvos no gtsFormData:');
                            print(controller.gtsFormData[controller.currentGtsIndex]);

                            controller.markStepAsCompleted(1); // marca step como concluído
                            widget.onNextPressed!();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Por favor, preencha os campos obrigatórios.')),
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

