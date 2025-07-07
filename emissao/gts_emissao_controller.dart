import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import '../../../shared/login/model/empresa_model.dart';
import '../../../shared/login/service/empresa_service.dart';
import '../../../shared/login/service/login_service.dart';
import '../models/destino_model.dart';
import '../models/gts_model.dart';
import '../models/subproduto_model.dart';
import '../service/gts_service.dart';

enum GtsStatus { AGUARDA_UPLOAD, OUTRO_STATUS }

class GtsEmissaoController {
  final EmpresaService _empresaService = Modular.get<EmpresaService>();
  final GtsService _gtsService = Modular.get<GtsService>();

  var user = Modular.get<LoginService>().usuarioLogado;

  var empresaUser;

  @observable
  List<dynamic> tiposSubprodutos = [];

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
  void initState() {
    getEmpresaUser();
  }

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

  @action
  void markStepAsCompleted(int stepIndex) {
    if (!doneSteps.contains(stepIndex)) {
      doneSteps.add(stepIndex);
    }
  }

  bool _validateStep(int stepIndex) {
    print('Validando etapa: $stepIndex');
    return true;
  }

  bool canNavigateToStep(int stepIndex) {
    return stepIndex < detalhesIndex || doneSteps.contains(stepIndex) || stepIndex == detalhesIndex + 1;
  }

  Future<void> loadTiposSubprodutosList() async {
    try {
      final tiposSubprodutosList = await _gtsService.getAllTiposSubprodutos();
      print('Retorno do service: $tiposSubprodutosList');
      tiposSubprodutos = tiposSubprodutosList;

    } catch (e) {
      print(e);
    }
  }

  Future<void> getEmpresaUser() async {
    loading = true;

    if (user?.uuid != null) {
       List<EmpresaModel> aux = await EmpresaService().getEmpresasByUsuario(user!.uuid!);
        empresaUser = aux[0];

        print(aux[0].toJson());
        //empresaUser = empresa;
    } else {
      print("Empresa nao encontrada");
    }
    loading = false;
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

  GtsModel construirGtsModelParaEnvio() {
    final dados = gtsFormData[currentGtsIndex];

    return GtsModel(
      origemNomeFantasia: dados['origemNomeFantasia'],
      origemCpfCnpj: dados['origemCpfCnpj'],
      origemInscricaoEstadual: dados['origemInscricaoEstadual'],

      tipoSubproduto: dados['tipoSubproduto'],
      transporte: dados['transporte'],
      dataValidade: dados['dataValidade'],
      lacre: List<String>.from(dados['lacre'] ?? []),

      descricao: dados['descricao'],
      destino: DestinoModel(
        nome: dados['destinoNomeFantasia'],
        cnpjCpf: dados['destinoCpfCnpj'],
        cep: dados['destinoCep'],
        logradouro: dados['destinoLogradouro'],
        numero: dados['destinoNumero'],
        complemento: dados['destinoComplemento'],
        cidade: dados['destinoMunicipio'],
        uf: dados['destinoUF'],
      ),
      subprodutos: [
        SubprodutoModel(
          quantidade: dados['quantidade'],
          lote: dados['lote'],
          peso: dados['peso'],
          //tratamento: dados['tratamento'], // novo campo
          finalidade: dados['finalidade'],
          unidadeMedida: dados['unidadeMedida'],
        )
      ],
    );
  }

}

