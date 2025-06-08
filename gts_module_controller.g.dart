// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gts_module_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$GtsModuleController on _GtsModuleControllerBase, Store {
  late final _$empresaAtom =
  Atom(name: '_GtsModuleControllerBase.empresa', context: context);

  @override
  EmpresaModel? get empresa {
    _$empresaAtom.reportRead();
    return super.empresa;
  }

  @override
  set empresa(EmpresaModel? value) {
    _$empresaAtom.reportWrite(value, super.empresa, () {
      super.empresa = value;
    });
  }

  late final _$empresasAtom =
  Atom(name: '_GtsModuleControllerBase.empresas', context: context);

  @override
  List<EmpresaModel> get empresas {
    _$empresasAtom.reportRead();
    return super.empresas;
  }

  @override
  set empresas(List<EmpresaModel> value) {
    _$empresasAtom.reportWrite(value, super.empresas, () {
      super.empresas = value;
    });
  }

  late final _$backgroundTaskAtom =
  Atom(name: '_GtsModuleControllerBase.backgroundTask', context: context);

  @override
  String? get backgroundTask {
    _$backgroundTaskAtom.reportRead();
    return super.backgroundTask;
  }

  @override
  set backgroundTask(String? value) {
    _$backgroundTaskAtom.reportWrite(value, super.backgroundTask, () {
      super.backgroundTask = value;
    });
  }

  late final _$userModulesAtom =
  Atom(name: '_GtsModuleControllerBase.userModules', context: context);

  @override
  List<ModuleModel>? get userModules {
    _$userModulesAtom.reportRead();
    return super.userModules;
  }

  @override
  set userModules(List<ModuleModel>? value) {
    _$userModulesAtom.reportWrite(value, super.userModules, () {
      super.userModules = value;
    });
  }

  late final _$loadingAtom =
  Atom(name: '_GtsModuleControllerBase.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$processingAtom =
  Atom(name: '_GtsModuleControllerBase.processing', context: context);

  @override
  bool get processing {
    _$processingAtom.reportRead();
    return super.processing;
  }

  @override
  set processing(bool value) {
    _$processingAtom.reportWrite(value, super.processing, () {
      super.processing = value;
    });
  }

  late final _$prefetchAsyncAction =
  AsyncAction('_GtsModuleControllerBase.prefetch', context: context);

  @override
  Future<void> prefetch() {
    return _$prefetchAsyncAction.run(() => super.prefetch());
  }

  late final _$_GtsModuleControllerBaseActionController =
  ActionController(name: '_GtsModuleControllerBase', context: context);

  @override
  void setEmpresa(EmpresaModel? empresa) {
    final _$actionInfo = _$_GtsModuleControllerBaseActionController
        .startAction(name: '_GtsModuleControllerBase.setEmpresa');
    try {
      return super.setEmpresa(empresa);
    } finally {
      _$_GtsModuleControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBackgroundTask(String? task) {
    final _$actionInfo = _$_GtsModuleControllerBaseActionController
        .startAction(name: '_GtsModuleControllerBase.setBackgroundTask');
    try {
      return super.setBackgroundTask(task);
    } finally {
      _$_GtsModuleControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void cleanBackgroundTask() {
    final _$actionInfo = _$_GtsModuleControllerBaseActionController
        .startAction(name: '_GtsModuleControllerBase.cleanBackgroundTask');
    try {
      return super.cleanBackgroundTask();
    } finally {
      _$_GtsModuleControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
empresa: ${empresa},
empresas: ${empresas},
backgroundTask: ${backgroundTask},
userModules: ${userModules},
loading: ${loading},
processing: ${processing}
    ''';
  }
}
