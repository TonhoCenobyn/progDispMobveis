import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../models/response_model.dart';
import '../models/gts_model.dart';
import '../service/gts_service.dart';
import 'gts_historico_page.dart'; // Para importar o GtsModel

class GtsHistoricoController {
  final GtsService _gtsService = Modular.get<GtsService>();

  // ValueNotifier para gerenciar o estado da lista de GTSs
  final ValueNotifier<List<GtsModel>> gtsListNotifier = ValueNotifier<List<GtsModel>>([]);

  // ValueNotifier para gerenciar o estado de carregamento
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  // Getter para acessar a lista atual de GTSs
  List<GtsModel> get gtsList => gtsListNotifier.value;

  final ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);

  Future<void> carregarGtsList() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final gtsList = await _gtsService.getAllGts();

      /*print("LISTA NO METODO CHAMADOR: ${gtsList.length} itens");
      for (final gts in gtsList) {
        print(gts.toJson()); // se GtsModel tiver toJson implementado
      }*/

      if (!gtsList.isEmpty) {
        gtsListNotifier.value = gtsList;
      } else {
        errorMessage.value = 'Erro ao carregar GTSs';
      }
    } catch (error) {
      errorMessage.value = 'Erro inesperado ao carregar GTSs';
      debugPrint('Erro ao carregar lista de GTSs: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> atualizarGtsList() async {
    await carregarGtsList();
  }

  /*Future<File?> getPdfFile(GtsModel gts) {
    //return _$getPdfFileAsyncAction.run(() => super.getPdfFile(auto));
    return File.fromUri('aaa');
  }*/


  String getGtsNumero(GtsModel gts) {
    return gts.numero ?? 'N/A';
  }

  String getGtsOrigem(GtsModel gts) {
    return gts.origemNomeFantasia ?? gts.origemCpfCnpj ?? 'Origem não informada';
  }

  String getGtsDestino(GtsModel gts) {
    if (gts.destino != null) {
      return gts.destino!.nome ?? gts.destino!.cnpjCpf ?? 'Destino não informado';
    }
    return 'Destino não informado';
  }

  String getGtsDataEmissao(GtsModel gts) {
    if (gts.dataEmissao != null) {
      final data = gts.dataEmissao!;
      return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
    }
    return 'Data não informada';
  }

  /// Método para verificar se há dados carregados
  bool get temDados => gtsList.isNotEmpty;

  /// Método para limpar mensagem de erro
  void limparErro() {
    errorMessage.value = null;
  }

  /// Método para limpar os dados quando o controller for descartado
  void dispose() {
    gtsListNotifier.dispose();
    isLoading.dispose();
    errorMessage.dispose();
  }

  /// Método privado que simula uma chamada de API
  /// SUBSTITUA este método pela implementação real da sua API
  Future<List<GtsModel>> _buscarGtsListFromApi() async {
    final List<Map<String, dynamic>> mockData = [
      {
        'numero': '000407',
        'origem': 'Frigorífico 1',
        'destino': 'Frigorífico 2',
        'dataEmissao': '21/04/2025',
      },
      {
        'numero': '000512',
        'origem': 'Frigorífico 1',
        'destino': 'Frigorífico 2',
        'dataEmissao': '04/09/2025',
      },
      {
        'numero': '000513',
        'origem': 'Frigorífico 3',
        'destino': 'Frigorífico 1',
        'dataEmissao': '05/09/2025',
      },
      {
        'numero': '000514',
        'origem': 'Frigorífico 2',
        'destino': 'Frigorífico 4',
        'dataEmissao': '06/09/2025',
      },
    ];

    // Converte os dados mockados para objetos GtsModel
    return mockData.map((json) => GtsModel.fromJson(json)).toList();
  }
}

