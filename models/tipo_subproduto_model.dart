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

class TipoSubprodutoModel implements CachePost {
  TipoSubprodutoModel({
    this.id,
    //ORIGEM
    this.nome,
    this.descricao,
    this.uuidCache,
  });
  static const String currentVersion = '0.0.1';

  //ORIGEM
  int? id;
  String? nome;
  String? descricao;

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
      'nome': nome,
      'descricao': descricao,
    };
  }

  fromMap(Map<String, dynamic> map) {
    return TipoSubprodutoModel(
      id: map['id']?.toInt(),
      nome: map['nome'] ?? '',
      descricao: map['descricao'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
    };
  }

  factory TipoSubprodutoModel.fromJson(Map<String, dynamic> json) {
    return TipoSubprodutoModel(
      id: json['id'] ?? '', //tinha q ser numero
      nome: json['nome'] ?? '',
      descricao: json['descricao'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toMapCache() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
    };
  }

  factory TipoSubprodutoModel.fromMapCache(Map<String, dynamic> map, String? uuidCache) {
    return TipoSubprodutoModel(
      id: map['id'],
      nome: map['nome'],
      descricao: map['descricao'],

      uuidCache: uuidCache,
    );
  }

  @override
  Future<bool> cacheIt(bool prontoSincronizar, {String versao = TipoSubprodutoModel.currentVersion}) async {
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

  TipoSubprodutoModel _createTipoSubprodutoFromApiResponse(Map<String, dynamic> json) {
    return TipoSubprodutoModel(
        id: json['id'],
        nome: json['nome'],
        descricao: json['descricao']);
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
