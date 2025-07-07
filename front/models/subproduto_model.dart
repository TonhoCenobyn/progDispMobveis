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

class SubprodutoModel implements CachePost {
  SubprodutoModel({
    this.quantidade,
    this.lote,
    this.peso,
    this.tratamento,
    this.finalidade,
    this.unidadeMedida,
  });
  static const String currentVersion = '0.0.1';
  String? quantidade;
  String? lote;
  String? peso;
  String? tratamento;
  String? finalidade;
  String? unidadeMedida;

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
      'quantidade': quantidade,
      'lote': lote,
      'peso': peso,
      'tratamento': tratamento,
      'finalidade': finalidade,
      'unidadeMedida': unidadeMedida,
    };
  }

  Map<String, dynamic> toJson() => {
    'quantidade': quantidade,
    'lote': lote,
    'peso': peso,
    'tratamento': tratamento,
    'finalidade': finalidade,
    'unidadeMedida': unidadeMedida,
  };

  factory SubprodutoModel.fromJson(Map<String, dynamic> json) {
    return SubprodutoModel(
      quantidade: json['quantidade'].toString(),
      lote: json['lote'].toString(),
      peso: json['peso'].toString(),
      tratamento: json['tratamento'],
      finalidade: json['finalidade'],
      unidadeMedida: json['unidadeMedida'],
    );
  }

  @override
  Map<String, dynamic> toMapCache() {
    return {
      'quantidade': quantidade,
      'lote': lote,
      'peso': peso,
      'tratamento': tratamento,
      'finalidade': finalidade,
      'unidadeMedida': unidadeMedida,
    };
  }

  factory SubprodutoModel.fromMapCache(Map<String, dynamic> map, String? uuidCache) {
    return SubprodutoModel(
      quantidade: map['quantidade'],
      lote: map['lote'],
      peso: map['peso'],
      tratamento: map['tratamento'],
      finalidade: map['finalidade'],
      unidadeMedida: map['unidadeMedida'],
    );
  }

  @override
  Future<bool> cacheIt(bool prontoSincronizar, {String versao = SubprodutoModel.currentVersion}) async {
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

  fromJson(json) {
    return SubprodutoModel(
      quantidade: json['quantidade'],
      lote: json['lote'],
      peso: json['peso'],
      tratamento: json['tratamento'],
      finalidade: json['finalidade'],
      unidadeMedida: json['unidadeMedida'],
    );
  }
}

