import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../models/tipo_subproduto_model.dart';
import '../gts_emissao_controller.dart';

class DetalhesStep3Page extends StatefulWidget {
  // Callbacks para navegação
  final VoidCallback? onNextPressed;
  final VoidCallback? onPreviousPressed;

  const DetalhesStep3Page({
    super.key,
    this.onNextPressed,
    this.onPreviousPressed,
  });


  @override
  State<DetalhesStep3Page> createState() => _DetalhesStep3PageState();
}

class _DetalhesStep3PageState extends State<DetalhesStep3Page> {
  String? _selectedTipoGts;
  String? _selectedTransporte;
  String? _selectedFinalidade;
  DateTime? _dataSelecionada;
  final GtsEmissaoController controller = Modular.get<GtsEmissaoController>();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _lacreController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final List<String> _lacresAdicionados = [];

  final Map<String, String> transportes = {
    'A PÉ': 'A_PE',
    'AÉREO': 'AEREO',
    'FERROVIÁRIO': 'FERROVIARIO',
    'MARÍTIMO/FLUVIAL': 'MARITIMO_FLUVIAL',
    'RODOVIÁRIO': 'RODOVIARIO',
  };


  @override
  void dispose() {
    _lacreController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    controller.loadTiposSubprodutosList();
  }

  // --- Funções para Lacres ---
  void _adicionarLacre() {
    final lacre = _lacreController.text.trim();
    if (lacre.isNotEmpty && !_lacresAdicionados.contains(lacre)) {
      setState(() {
        _lacresAdicionados.add(lacre);
      });
      _lacreController.clear();
      FocusManager.instance.primaryFocus?.unfocus(); // Esconde o teclado
    } else if (lacre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite o número do lacre.'), backgroundColor: Colors.orange),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lacre "$lacre" já adicionado.'), backgroundColor: Colors.orange),
      );
    }
  }

  void _removerLacre(String lacre) {
    setState(() {
      _lacresAdicionados.remove(lacre);
    });
  }
  // --------------------------

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
                  'Identificação  ',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<String>(
                  value: _selectedTipoGts,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de subproduto *',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Ossos e produtos variados', 'Peles animais tratadas ou não', 'Cascos ou chifres e seus derivados']
                      .map((label) => DropdownMenuItem(
                    value: label,
                    child: Text(label),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTipoGts = value;
                    });
                  },
                  validator: (value) =>
                  value == null ? 'Selecione o tipo de GTS' : null,
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<String>(
                  value: _selectedTransporte,
                  decoration: const InputDecoration(
                    labelText: 'Transporte',
                    border: OutlineInputBorder(),
                  ),
                  items: transportes.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.value, // valor que será salvo
                      child: Text(entry.key), // texto visível
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTransporte = value;
                    });
                  },
                  validator: (value) =>
                  value == null ? 'Selecione o tipo de transporte' : null,
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<String>(
                  value: _selectedFinalidade,
                  decoration: const InputDecoration(
                    labelText: 'Finalidade',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Industrialização', 'Outros']
                      .map((label) => DropdownMenuItem(
                    value: label,
                    child: Text(label),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFinalidade = value;
                    });
                  },
                  validator: (value) =>
                  value == null ? 'Selecione o tipo de finalidade' : null,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _dateController, // Use o controller
                  decoration: const InputDecoration(
                    labelText: 'Data da Emissão *',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      // Formate a data e atualize o controller
                      String formattedDate = "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
                      setState(() {
                        _dateController.text = formattedDate;
                        _dataSelecionada = pickedDate;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'A data de emissão é obrigatória';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _lacreController,
                  decoration: InputDecoration(
                    labelText: 'Número do Lacre',
                    border: const OutlineInputBorder(),
                    hintText: 'Digite o número e adicione',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      tooltip: 'Adicionar Lacre',
                      onPressed: _adicionarLacre,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (_) => _adicionarLacre(),
                ),
                const SizedBox(height: 16),

                if (_lacresAdicionados.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: _lacresAdicionados.map((lacre) {
                        return Chip(
                          label: Text(lacre),
                          onDeleted: () => _removerLacre(lacre),
                          deleteIcon: const Icon(Icons.cancel, size: 18),
                        );
                      }).toList(),
                    ),
                  )
                else

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),

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

                    if (widget.onNextPressed != null)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Avançar'),
                        onPressed: () {
                          // Valida o formulário antes de avançar
                          // Adicione validação específica para esta etapa se necessário
                          // Ex: if (!_aceitoTermos) { ... show error ... return; }
                          if (_formKey.currentState!.validate()) {
                            final controller = Modular.get<GtsEmissaoController>();

                            controller.gtsFormData[controller.currentGtsIndex].addAll({
                              'tipoSubproduto': _selectedTipoGts,
                              'transporte': _selectedTransporte,
                              'finalidade': _selectedFinalidade,
                              'dataValidade': _dataSelecionada,
                              'lacre': _lacresAdicionados,
                            });


                            controller.markStepAsCompleted(2); // marca step como concluído
                            widget.onNextPressed!();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Por favor, preencha os campos obrigatórios e aceite os termos.')),
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

