import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../shared/login/service/login_service.dart';
import '../gts_emissao_controller.dart';

class DetalhesStep1Page extends StatefulWidget {
  // Callbacks para navegação
  final VoidCallback? onNextPressed;
  final VoidCallback? onPreviousPressed; // Será null na primeira etapa


  const DetalhesStep1Page({
    super.key,
    required this.onNextPressed,
    this.onPreviousPressed,
  });

  @override
  State<DetalhesStep1Page> createState() => _DetalhesStep1PageState();
}

class _DetalhesStep1PageState extends State<DetalhesStep1Page> {
  String? _selectedTipoGts;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final _nomeFantasiaController = TextEditingController();
  final _cpfCnpjController = TextEditingController();
  final _inscricaoEstadualController = TextEditingController();
  final controller = Modular.get<GtsEmissaoController>();

  var user = Modular.get<LoginService>().usuarioLogado;
  var empresaUser;

  @override
  void initState() {
    super.initState();

    controller.getEmpresaUser().then((_) {
      final empresa = controller.empresaUser;
      print(empresa);
      if (empresa != null) {
        _nomeFantasiaController.text = empresa.nomeFantasia ?? '';
        _cpfCnpjController.text = empresa.cnpj ?? '';
      }
    });
  }

  @override
  void dispose() {
    _nomeFantasiaController.dispose();
    _cpfCnpjController.dispose();
    _inscricaoEstadualController.dispose();
    _dateController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder para obter o contexto correto para o ScaffoldMessenger
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Campos do formulário originais...
                Text(
                  'Estabelecimento de Origem',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  readOnly: true,
                  controller:  _nomeFantasiaController,
                  decoration: const InputDecoration(
                    labelText: 'Nome Fantasia',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  /*validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O nome do estabelecimento é obrigatório';
                    }
                    return null;
                  },*/
                ),
                const SizedBox(height: 24),
                TextFormField(
                  readOnly: true,
                  controller: _cpfCnpjController,
                  decoration: const InputDecoration(
                    labelText: 'CPF/CNPJ',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  /*validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O CPF/CNPJ é obrigatório';
                    }
                    return null;
                  },*/
                ),
                const SizedBox(height: 24),
                TextFormField(
                  readOnly: true,
                  controller: _inscricaoEstadualController,
                  decoration: const InputDecoration(
                    labelText: 'Inscrição Estadual',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  /*validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'A inscrição estadual é obrigatória';
                    }
                    return null;
                  },*/
                ),
                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Botão Voltar (só aparece se houver callback)
                    if (widget.onPreviousPressed != null)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Voltar'),
                        onPressed: widget.onPreviousPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                      )
                    else
                      const SizedBox.shrink(),

                    if (widget.onNextPressed != null)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Avançar'),
                        onPressed: () {
                          // Valida o formulário antes de avançar
                          if (_formKey.currentState!.validate()) {
                            final controller = Modular.get<GtsEmissaoController>();

                            controller.gtsFormData[controller.currentGtsIndex].addAll({
                              'origemNomeFantasia': _nomeFantasiaController.text,
                              'origemCpfCnpj': _cpfCnpjController.text,
                              'origemInscricaoEstadual': _inscricaoEstadualController.text,
                            });

                            print('Dados salvos no gtsFormData:');
                            print(controller.gtsFormData[controller.currentGtsIndex]);

                            controller.markStepAsCompleted(0); // marca step como concluído
                            widget.onNextPressed!();
                          } else {
                            // Mostra uma mensagem se a validação falhar
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
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

