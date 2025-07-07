import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:path_provider/path_provider.dart';
import '../../../shared/login/service/login_service.dart';
import '../../../../core/helpers/helper.dart';
import '../../../../services/abstract_service.dart';
import '../../../../core/helpers/env.dart';
import '../../../../extensions/int.dart';
import '../../../../models/response_model.dart';
import '../models/destino_model.dart';
import '../models/gts_model.dart';
import '../models/subproduto_model.dart';
import '../models/tipo_subproduto_model.dart';

class GtsService extends AbstractService {
  final LoginService loginService = Modular.get();

  Future<ResponseModel> postGts(GtsModel gts) async {
    try {
      final formData = FormData.fromMap({
        'gtsForm': jsonEncode(await gts.toMap()),
        'uuid_sync': gts.uuidCache,
        'data_hora_preenchimento_app': gts.dataHoraCache?.dateFromMillis(formato: 'yyyy-MM-ddTHH:mm:ss')
      });

      final response = await super.auth().postPadronizado(
        '${Env.dtamUrl}/bff-app/gts',
        formData,
        supressMsgs: true,
      );

      log('STATUS: ${response.status}');
      log('MSG: ${response.msg}');
      log('RAW BODY: ${response.data}');

      return response;
    } catch (e) {
      log(e.toString());
      return ResponseModel(status: ResponseStatus.ERROR, msg: "Houve um erro ao sincronizar a GTS, tente novamente.");
    }
  }

  Future<List<GtsModel>> getAllGts() async {
    try {
      final response = await super.auth().getPadronizado(
        '${Env.dtamUrl}/bff-app/gts',
      );

      if (response.status == ResponseStatus.SUCCESS) {

        final List<dynamic> gtsListJson = response.data is List
            ? response.data
            : response.data['data'] ?? response.data['gtsList'] ?? [];

        final List<GtsModel> gtsList = [];

        for (var json in gtsListJson) {
          print("ITEM VINDO DO BACK:");
          print(json);
          try {
            final gts = _createGtsFromApiResponse(json as Map<String, dynamic>);
            print("OBJETO GTS MODEL MONTADO: ");
            print(gts.toJson());
            gtsList.add(gts);
          } catch (e, stack) {
            print(stack);
          }
        }
        //print(gtsList.toString());
        return gtsList;
      } else {
        print('STATUS FOI ERRO: ${response.status}');
      }
    } catch (e, stacktrace) {
      log('Erro na requisição getAllGts: $e');
      log('STACKTRACE: $stacktrace');
    }

    // Garantia de retorno
    return [];
  }

  Future<List<TipoSubprodutoModel>> getAllTiposSubprodutos() async {
    try {
      final response = await super.auth().getPadronizado(
        '${Env.dtamUrl}/bff-app/gts/tipos_subprodutos',
      );

      if (response.status == ResponseStatus.SUCCESS) {

        final List<dynamic> tiposSubprodutosListJson = response.data is List
            ? response.data
            : response.data['data'] ?? response.data['tiposSubprodutosList'] ?? [];

        final List<TipoSubprodutoModel> tiposSubprodutosList = [];

        for (var json in tiposSubprodutosListJson) {
          print("Tipo subproduto vindo do back");
          print(json);
          try {
            final tiposSubprodutos = TipoSubprodutoModel.fromJson(json);
            tiposSubprodutosList.add(tiposSubprodutos);
          } catch (e, stack) {
            print(stack);
          }
        }
        return tiposSubprodutosList;
      } else {
        print('STATUS FOI ERRO: ${response.status}');
      }
    } catch (e, stacktrace) {
      log('Erro na requisição getAllTiposSubprodutos: $e');
      log('STACKTRACE: $stacktrace');
    }

    return [];
  }

  Future<File?> getPdfFile(GtsModel gts) async {
    final url = '${Env.dtamUrl}/bff-app/gts/pdf/${gts.uuid}';
    final response = await super.auth().getPadronizado(url);
    if (response.data != null) {
      final dir = await getTemporaryDirectory();
      final file = File("${dir.path}/gts_temp_${gts.uuid}.pdf");
      final bytes = Helper.base64ToUint8List(response.data);
      await file.writeAsBytes(bytes, flush: true);
      return file;
    }
    return null;
  }

  GtsModel _createGtsFromApiResponse(Map<String, dynamic> json) {
    final origemJson = json['origem'] ?? {};
    final destinoJson = json['destino'];
    final subprodutosJson = json['subprodutos'];

    return GtsModel(
      id: json['id'],
      numero: json['numero'],
      dataEmissao: json['dataValidade'] != null
          ? DateTime.tryParse(json['dataValidade'])
          : null,
      origemNomeFantasia: origemJson['nomeFantasia'],
      origemCpfCnpj: origemJson['cnpj'],
      origemInscricaoEstadual: origemJson['inscricaoEstadual'],
      destino: destinoJson != null
          ? DestinoModel.fromJson(destinoJson)
          : null,
      subprodutos: subprodutosJson != null
          ? (subprodutosJson as List)
          .map<SubprodutoModel>((item) =>
          SubprodutoModel.fromJson(item as Map<String, dynamic>))
          .toList()
          : [],
      tipoSubproduto: json['tipoSubproduto'],
      transporte: json['transporte'],
      dataValidade: json['dataValidade'] != null
          ? DateTime.tryParse(json['dataValidade'])
          : null,
      lacre: json['lacre'] != null
          ? List<String>.from(json['lacre'])
          : [],

      descricao: json['descricao'],
      uuidCache: json['uuidCache'] ?? json['uuid'] ?? json['id'],
    );
  }
}