import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

enum GtsStatus { AGUARDA_UPLOAD, OUTRO_STATUS }

class GtsEmissaoController {
  @observable
  bool loading = false;

  @observable
  int detalhesIndex = 0;

  @observable
  bool isEditingStep1 = true;

  @observable
  ObservableList<int> doneSteps = ObservableList<int>();

  @observable
  ObservableList<Map<String, dynamic>> gtsFormData = ObservableList.of([
    {'status': GtsStatus.AGUARDA_UPLOAD}
  ]);

  @observable
  int currentGtsIndex = 0;

  final PageController pageController = PageController(initialPage: 0);

  final int totalSteps = 4; // Número total de etapas do formulário

  @computed
  bool get canFinishForm => doneSteps.length == totalSteps;

  // --- Actions ---

  @action
  void setLoading(bool value) {
    loading = value;
  }

  @action
  void _updateCurrentStepIndex(int page) {
    if (page >= 0 && page < totalSteps) {
      detalhesIndex = page;
    }
  }

  @action
  void nextStep() {
    if (detalhesIndex < totalSteps - 1) {
      final nextPage = detalhesIndex + 1;
      _updateCurrentStepIndex(nextPage);
      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @action
  void prevStep() {
    if (detalhesIndex > 0) {
      final previousPage = detalhesIndex - 1;
      _updateCurrentStepIndex(previousPage);
      pageController.animateToPage(
        previousPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @action
  void goToStep(int page) {
    if (page >= 0 && page < totalSteps /*&& canNavigateToStep(page)*/) {
      _updateCurrentStepIndex(page);
      pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  // Ação para marcar etapa como concluída (usada no botão Avançar)
  @action
  void markStepAsCompleted(int stepIndex) {
    if (!doneSteps.contains(stepIndex)) {
      doneSteps.add(stepIndex);
      // doneSteps.sort(); // Ordenar se necessário
    }
  }

  bool _validateStep(int stepIndex) {
    print('Validando etapa: $stepIndex');
    return true;
  }

  bool canNavigateToStep(int stepIndex) {
    return stepIndex < detalhesIndex || doneSteps.contains(stepIndex) || stepIndex == detalhesIndex + 1;
  }

  // --- Lifecycle ---

  @action
  void resetController() {
    loading = false;
    detalhesIndex = 0;
    isEditingStep1 = true;
    doneSteps.clear();
    gtsFormData[currentGtsIndex] = {'status': GtsStatus.AGUARDA_UPLOAD}; // Resetar dados do form
    pageController.jumpToPage(0);
  }

  void dispose() {
    print('Disposing GtsEmissaoController');
    pageController.dispose();
  }
}

