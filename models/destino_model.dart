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

class DestinoModel implements CachePost {
  DestinoModel({
    this.nome,
    this.cnpjCpf,
    this.cep,
    this.logradouro,
    this.numero,
    this.complemento,
    this.cidade,
    this.uf,
  });
  static const String currentVersion = '0.0.1';
  //DESTINO
  String? nome;
  String? cnpjCpf;
  String? cep;
  String? logradouro;
  String? numero;
  String? complemento;
  String? cidade;
  String? uf;

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
      'nome': nome,
      'cnpjCpf': cnpjCpf,
      'cep': cep,
      'logradouro': logradouro,
      'numero': numero,
      'complemento': complemento,
      'cidade': cidade,
      'uf': uf,
    };
  }

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'cnpjCpf': cnpjCpf,
    'cep': cep,
    'logradouro': logradouro,
    'numero': numero,
    'complemento': complemento,
    'cidade': cidade,
    'uf': uf,
  };

  factory DestinoModel.fromJson(Map<String, dynamic> json) {
    return DestinoModel(
      nome: json['nome'] ?? '',
      cnpjCpf: json['cnpjCpf'] ?? '',
      cep: json['cep'] ?? '',
      logradouro: json['logradouro'] ?? '',
      numero: json['numero'],
      complemento: json['complemento'],
      cidade: json['cidade'],
      uf: json['uf'],
    );
  }

  @override
  Map<String, dynamic> toMapCache() {
    return {
      //DESTINO
      'nome': nome,
      'cnpjCpf': cnpjCpf,
      'cep': cep,
      'logradouro': logradouro,
      'numero': numero,
      'complemento': complemento,
      'cidade': cidade,
      'uf': uf,
    };
  }

  factory DestinoModel.fromMapCache(Map<String, dynamic> map, String? uuidCache) {
    return DestinoModel(
      //DESTINO
      nome: map['nome'],
      cnpjCpf: map['cnpjCpf'],
      cep: map['cep'],
      logradouro: map['logradouro'],
      numero: map['numero'],
      complemento: map['complemento'],
      cidade: map['cidade'],
      uf: map['uf'],
    );
  }

  @override
  Future<bool> cacheIt(bool prontoSincronizar, {String versao = DestinoModel.currentVersion}) async {
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
    return DestinoModel(
      nome: json['nome'] ?? '',
      cnpjCpf: json['cnpjCpf'] ?? '',
      cep: json['destino'] ?? '',
      logradouro: json['dataValidade'] ?? '',
      numero: json['numero'],
      complemento: json['complemento'],
      cidade: json['cidade'],
      uf: json['uf'],
    );
  }
}
