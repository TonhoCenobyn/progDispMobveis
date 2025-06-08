import 'package:flutter/material.dart';

// Importe as páginas de cada etapa
import 'formulario/detalhes_step1.dart';
import 'formulario/detalhes_step2.dart';
import 'formulario/detalhes_step3.dart';
import 'formulario/detalhes_step4.dart';

class GtsEmissaoPage extends StatefulWidget {
  const GtsEmissaoPage({super.key});

  @override
  State<GtsEmissaoPage> createState() => _GtsEmissaoPageState();
}

class _GtsEmissaoPageState extends State<GtsEmissaoPage> {
  int _currentStepIndex = 0;
  final int _totalSteps = 4;

  // Função para ir para a próxima etapa
  void _nextStep() {
    if (_currentStepIndex < _totalSteps - 1) {
      setState(() {
        _currentStepIndex++;
      });
    }
  }

  // Função para voltar para a etapa anterior
  void _previousStep() {
    if (_currentStepIndex > 0) {
      setState(() {
        _currentStepIndex--;
      });
    }
  }

  // Função para finalizar (exemplo)
  void _finishForm() {
    print('Formulário GTS Finalizado!');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('GTS Emitida com Sucesso (Simulação)!')),
    );
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

