import 'dart:convert';

import 'package:uuid/uuid.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';
import 'package:uuid/uuid.dart';
import 'package:mobx/mobx.dart';
import 'dart:io';

import '../../../../core/cache/cache_enums.dart';
import '../../../../core/cache/cache_generico_repository.dart';
import '../../../../core/cache/cache_post.dart';
import '../../../../core/cache/cache_post_model.dart';
import '../../../../core/cache/cache_post_row_model.dart';
import 'destino_model.dart';
import 'subproduto_model.dart';

class GtsModel implements CachePost {
  GtsModel({
    this.id,
    this.uuid,
    this.numero,
    this.dataEmissao,
    //ORIGEM
    this.origemNomeFantasia,
    this.origemCpfCnpj,
    this.origemInscricaoEstadual,


    //DESTINO
    this.destino,

    //IDENTIFICACAO
    this.subprodutos,
    this.tipoSubproduto,
    this.transporte,
    this.dataValidade,
    this.lacre,

    //CARACTERISTICAS
    this.descricao,

    this.uuidCache,
  });
  static const String currentVersion = '0.0.1';

  //ORIGEM
  int? id;
  String? uuid;
  String? numero;
  DateTime? dataEmissao;
  String? origemNomeFantasia;
  String? origemCpfCnpj;
  String? origemInscricaoEstadual;

  //IDENTIFICACAO
  String? tipoSubproduto;
  String? transporte;
  DateTime? dataValidade;
  List<String>? lacre;

  //CARACTERISTICAS
  String? descricao;

  // Modelos aninhados
  DestinoModel? destino;
  List<SubprodutoModel>? subprodutos;


  @override
  int? dataHoraCache;

  @override
  String? uuidCache;


  Future<Map<String, dynamic>> toMap() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final String platform = Platform.isAndroid
        ? "Android"
        : Platform.isIOS
        ? "iOS"
        : "undefined";

    late AndroidDeviceInfo androidInfo;
    late IosDeviceInfo iosInfo;

    if (Platform.isAndroid) {
      androidInfo = await deviceInfo.androidInfo;
    } else if (Platform.isIOS) {
      iosInfo = await deviceInfo.iosInfo;
    }
    return {
      'id': id,
      'uuid': uuid,
      'numero': numero,
      'dataEmissao': dataEmissao,
      'origemNomeFantasia': origemNomeFantasia,
      'origemCpfCnpj': origemCpfCnpj,
      'origemInscricaoEstadual': origemInscricaoEstadual,

      //IDENTIFICACAO
      'tipoSubproduto': tipoSubproduto,
      'transporte': transporte,
      'dataValidade': dataValidade?.toIso8601String(),
      'lacre': lacre,

      //CARACTERISTICAS
      'descricao': descricao,

      'destino': destino,
      'subprodutos': subprodutos,

      'emissaoAgent': {
        "emissaoAgent": platform,
        "emissaoAgentVersion": platform == "Android"
            ? "${androidInfo.version.release.toString()} API ${androidInfo.version.sdkInt}"
            : platform == "iOS"
            ? iosInfo.systemVersion
            : "undefined"
      },
    };
  }

  fromMap(Map<String, dynamic> map) {
    return GtsModel(
      id: map['id']?.toInt(),
      uuid: map['uuid'] ?? '',
      numero: map['numero'] ?? '',
      dataEmissao: map['dataEmissao'],
      origemNomeFantasia: map['origemNomeFantasia'] ?? '',
      origemCpfCnpj: map['origemNomeFantasia'] ?? '',
      origemInscricaoEstadual: map['origemNomeFantasia'] ?? '',
      destino: map['destino'] ?? '',
      subprodutos: map['subprodutos'] ?? '',
      transporte: map['transporte'] ?? '',
      dataValidade: map['dataValidade'] ?? '',
      lacre: map['lacre'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'numero': numero,
      'dataEmissao': dataEmissao?.toIso8601String(),
      'origemNomeFantasia': origemNomeFantasia,
      'origemCpfCnpj': origemCpfCnpj,
      'origemInscricaoEstadual': origemInscricaoEstadual,
      'destino': destino?.toJson(),
      'subprodutos': subprodutos?.map((e) => e.toJson()).toList(),
      'descricao': descricao,
      'transporte': transporte,
      'dataValidade': dataValidade?.toIso8601String(),
      'lacre': lacre,
    };
  }

  factory GtsModel.fromJson(Map<String, dynamic> json) {
    return GtsModel(
      id: json['id'] ?? '',
      uuid: json['uuid'] ?? '',
      numero: json['numero'] ?? '',
      dataEmissao: json['dataEmissao'] ?? '',
      transporte: json['transporte'] ?? '', //tinha q ser numero
      origemNomeFantasia: json['origemNomeFantasia'] ?? '',
      destino: json['destino'] ?? '',
      dataValidade: json['dataValidade'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toMapCache() {
    return {
    'origemNomeFantasia': origemNomeFantasia,
    'origemCpfCnpj': origemCpfCnpj,
    'origemInscricaoEstadual': origemInscricaoEstadual,

    //IDENTIFICACAO
    'tipoSubproduto': tipoSubproduto,
    'transporte': transporte,
    'dataValidade': dataValidade?.toIso8601String(),
    'lacre': lacre,

    //CARACTERISTICAS
    'descricao': descricao,
    };
  }

  factory GtsModel.fromMapCache(Map<String, dynamic> map, String? uuidCache) {
    return GtsModel(
        origemNomeFantasia: map['origemNomeFantasia'],
        origemCpfCnpj: map['origemCpfCnpj'],
        origemInscricaoEstadual: map['origemInscricaoEstadual'],

        //IDENTIFICACAO
        tipoSubproduto: map['tipoSubproduto'],
        transporte: map['transporte'],
        dataValidade: DateTime.tryParse(map['dataValidade']),
        lacre: map['lacre'],

        //CARACTERISTICAS
        descricao: map['descricao'],
        uuidCache: uuidCache,
    );
  }

  @override
  Future<bool> cacheIt(bool prontoSincronizar, {String versao = GtsModel.currentVersion}) async {
    uuidCache ??= const Uuid().v1();
    dataHoraCache ??= DateTime.now().toUtc().millisecondsSinceEpoch;
    final map = toMapCache();
    CachePostModel post = CachePostModel(
      uuid: uuidCache,
      timestampMillis: dataHoraCache,
      dados: jsonEncode(map),
      tipo: TipoCachePost.GTS_MODEL.name,
      versao: versao,
    );
    final rowId = await CacheGenericoRepository().upsertCachePost(post, prontoSincronizar);
    return rowId != -1;
  }

  @override
  Future<bool> apagarFotoCache(String nome) {
    // TODO: implement apagarFotoCache
    throw UnimplementedError();
  }

  @override
  Future<bool> apagarFromCache() {
    // TODO: implement apagarFromCache
    throw UnimplementedError();
  }

  @override
  bool atualizarFotosCache() {
    // TODO: implement atualizarFotosCache
    throw UnimplementedError();
  }

  @override
  CachePostRowModel getRowData() {
    // TODO: implement getRowData
    throw UnimplementedError();
  }

  @override
  Future<bool> salvarFotosCache() {
    // TODO: implement salvarFotosCache
    throw UnimplementedError();
  }

  @override
  Future<bool> sincronizarCache(Future<bool> Function(dynamic p1) syncFunction) {
    // TODO: implement sincronizarCache
    throw UnimplementedError();
  }
}
