import 'package:flutter_modular/flutter_modular.dart';


import '../../../../services/form_service.dart';
import '../service/gts_service.dart';
import 'formulario/detalhes_step1.dart';
import 'gts_emissao_controller.dart';
import 'gts_emissao_page.dart';


class GtsEmissaoModule extends Module {
  @override
  List<Bind<Object>> get binds => [
    Bind.lazySingleton((i) => GtsService()),
    Bind.lazySingleton(
          (i) => GtsEmissaoController(),
    ),
    Bind.lazySingleton((i) => FormService()),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute(
      Modular.initialRoute,
      child: (context, args) => const GtsEmissaoPage(),
    ),
    ChildRoute(
      "/detalhes/",
      child: (context, args) => GtsEmissaoPage(),
      transition: TransitionType.rightToLeft,
    ),
  ];
}
