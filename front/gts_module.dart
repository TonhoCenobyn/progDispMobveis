import 'package:flutter_modular/flutter_modular.dart';

import 'emissao/formulario/detalhes_step1.dart';
import 'emissao/gts_emissao_module.dart';
import 'emissao/gts_emissao_page.dart';
import 'gts_module_controller.dart';
import 'historico/gts_historico_module.dart';
import 'home/gts_home_page.dart';
import 'service/gts_service.dart';
import 'service/gts_service.dart';
import 'gts_module_controller.dart';
import 'gts_module_page.dart';
import 'home/gts_home_controller.dart';
import 'home/gts_home_page.dart';

class GtsModule extends Module {
  @override
  List<Bind<Object>> get binds => [
    Bind.lazySingleton((i) => GtsService()),
    Bind.lazySingleton((i) => GtsHomeController()),
    Bind.lazySingleton(
          (i) => GtsModuleController(
        loginService: i.get(),
      ),
    ),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute(Modular.initialRoute, child: (context, args) => const GtsModulePage(), children: [
      ChildRoute(
        "/home",
        child: (context, args) => const GtsHomePage(),
      ),
      ModuleRoute(
        '/emissao',
        module: GtsEmissaoModule(), // ✅ CORRETO: Modular carrega os binds de emissão
      ),
      ModuleRoute(
        '/historico',
        module: GtsHistoricoModule(), // ✅ CORRETO: Modular carrega os binds de emissão
      ),
      /*ChildRoute(
        "/emissao",
        child: (context, args) => const GtsEmissaoPage(),
        transition: TransitionType.rightToLeft,
      ),*/
    ]),
  ];
}