import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

// Importe as páginas de cada etapa
import '../service/gts_service.dart';
import 'formulario/detalhes_step1.dart';
import 'formulario/detalhes_step2.dart';
import 'formulario/detalhes_step3.dart';
import 'formulario/detalhes_step4.dart';
import 'gts_emissao_controller.dart';

class GtsEmissaoPage extends StatefulWidget {
  const GtsEmissaoPage({super.key});

  @override
  State<GtsEmissaoPage> createState() => _GtsEmissaoPageState();


}

class _GtsEmissaoPageState extends State<GtsEmissaoPage> {
  int _currentStepIndex = 0;
  final int _totalSteps = 4;
  late final GtsEmissaoController controller;

  @override
  void initState() {
    super.initState();
    controller = Modular.get<GtsEmissaoController>();
    controller.initState();
  }

  void _nextStep() {
    if (_currentStepIndex < _totalSteps - 1) {
      setState(() {
        _currentStepIndex++;
      });
    }
  }

  void _previousStep() {
    if (_currentStepIndex > 0) {
      setState(() {
        _currentStepIndex--;
      });
    }
  }

  void _finishForm() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('GTS Emitida com Sucesso (Simulação)!')),
    );

    final controller = Modular.get<GtsEmissaoController>();
    final gts = controller.construirGtsModelParaEnvio();

    final cacheSuccess = await gts.cacheIt(true);
    if (!cacheSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar GTS em cache')),
      );
      return;
    }

    final response = await GtsService().postGts(gts);

    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('GTS emitida com sucesso!')),
      );
      // Pode navegar para uma tela de sucesso ou resetar o form:
      controller.resetController();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${response.msg}')),
      );
    }
  }

  Widget _buildStepContent() {
    switch (_currentStepIndex) {
      case 0:
        return DetalhesStep1Page(
          onNextPressed: _nextStep,
        );
      case 1:
        return DetalhesStep2Page(
          onNextPressed: _nextStep,
          onPreviousPressed: _previousStep,
        );
      case 2:
        return DetalhesStep3Page(
          onNextPressed: _nextStep,
          onPreviousPressed: _previousStep,
        );
      case 3:
        return DetalhesStep4Page(
          onFinishPressed: _finishForm,
          onPreviousPressed: _previousStep,
        );
      default:
        return const Center(child: Text('Etapa desconhecida'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildStepContent(),

    );
  }
}

