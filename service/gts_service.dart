import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:uuid/uuid.dart';


import '../../../shared/login/service/login_service.dart';
import '../../../../services/abstract_service.dart';


class GtsService extends AbstractService {
  final LoginService loginService = Modular.get();

}