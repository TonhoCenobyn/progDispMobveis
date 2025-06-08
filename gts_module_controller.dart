import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobx/mobx.dart';

import '../../../core/ui/theme/app_colors.dart';
import '../../../core/utils/conectividade.dart';
import '../../../models/home/module_model.dart';
import '../../shared/login/model/empresa_model.dart';
import '../../shared/login/service/empresa_service.dart';
import '../../shared/login/service/login_service.dart';

part 'gts_module_controller.g.dart';

class GtsModuleController = _GtsModuleControllerBase with _$GtsModuleController;

abstract class _GtsModuleControllerBase with Store {
  _GtsModuleControllerBase({
    required this.loginService,
  });

  final LoginService loginService;

  @observable
  EmpresaModel? empresa;

  @observable
  List<EmpresaModel> empresas = [];

  @observable
  String? backgroundTask;

  Future<void> fetchEmpresasbyUser() async {
    loading = true;
    final usuarioLogado = loginService.usuarioLogado;
    if (usuarioLogado?.uuid != null) {
      List<EmpresaModel> aux = await EmpresaService().getEmpresasByUsuario(usuarioLogado!.uuid!);
      empresas = aux;
    } else {
      await loginService.logout();
      Modular.to.pushNamedAndRemoveUntil('/shared/login', (p0) => false);
    }
    loading = false;
  }

  @action
  void setEmpresa(EmpresaModel? empresa) {
    this.empresa = empresa;
  }

  @action
  void setBackgroundTask(String? task) {
    backgroundTask = task;
  }

  @action
  void cleanBackgroundTask() {
    backgroundTask = null;
  }

  @action
  Future<void> prefetch() async {
    final isOnline = await Conectividade.isOnline();

    if (isOnline) {
      setBackgroundTask('Preparando para emissão de GTS offline');

      /*await Future.wait([
        operadorService.getAll(),
        veiculoService.getAll(),
        dtamService.getEspecies(),
        assinaturaService.getAssinatura(),
        dtamService.getAllPaginado(
          PaginationFilter(
            pagina: 0,
            itensPorPagina: 15,
            busca: '',
            sortBy: 'data_emissao',
            sortByDirection: 'DESC',
          ),
        ),
      ]);*/

      await Future.delayed(Durations.extralong4);
      cleanBackgroundTask();
    }
  }

  List<ModuleModel> modules = [
    /*ModuleModel(
      title: 'PLANILHAS',
      icon: SvgPicture.asset(
        'assets/svg/exportacoes_icon.svg',
        color: AppColors.secundary,
        height: 40,
      ),
      route: '/sve/planilhas',
      isAvalible: true,
    ),*/
    ModuleModel(
      title: 'GTS',
      icon: SvgPicture.asset(
        'assets/svg/exportacoes_icon.svg',
        color: AppColors.secundary,
        height: 40,
      ),
      route: '/gts/home',
      isAvailable: true,
    ),
  ];

  @observable
  List<ModuleModel>? userModules;

  var user = Modular.get<LoginService>().usuarioLogado;

  @observable
  var loading = false;

  @observable
  var processing = false;
}