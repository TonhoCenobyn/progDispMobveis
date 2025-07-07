import 'package:flutter_modular/flutter_modular.dart';
import '../service/gts_service.dart';
import 'gts_historico_controller.dart';
import 'gts_historico_page.dart';

class GtsHistoricoModule extends Module {
  @override
  List<Bind> get binds => [
    // Registra o controller como singleton para manter o estado durante a navegação
    Bind.lazySingleton((i) => GtsService()),
    Bind.singleton((i) => GtsHistoricoController()),

    // Caso você tenha um service para chamadas de API, registre aqui também
    // Exemplo: Bind.singleton((i) => GtsHistoricoService()),
  ];

  @override
  List<ModularRoute> get routes => [
    // Rota principal para a página de histórico
    ChildRoute(
      '/',
      child: (context, args) => const GtsHistoricoPage(),
    ),

    // Rota alternativa caso você queira acessar diretamente
    ChildRoute(
      '/historico',
      child: (context, args) => const GtsHistoricoPage(),
    ),

    // Exemplo de rota para visualizar uma GTS específica (opcional)
    // ChildRoute(
    //   '/visualizar/:numero',
    //   child: (context, args) => GtsVisualizarPage(
    //     numero: args.params['numero'],
    //   ),
    // ),
  ];
}

/// Classe auxiliar para configuração do módulo no módulo principal da aplicação
/// Use esta classe para integrar o GtsHistoricoModule no seu AppModule principal
class GtsHistoricoModuleConfig {
  /// Método estático para obter as configurações de bind do módulo
  /// Útil se você quiser registrar as dependências diretamente no AppModule
  static List<Bind> getBinds() {
    return [
      Bind.singleton((i) => GtsHistoricoController()),
    ];
  }

  /// Método estático para obter as rotas do módulo
  /// Útil para integração com o sistema de rotas principal
  static List<ModularRoute> getRoutes() {
    return [
      ModuleRoute('/gts-historico', module: GtsHistoricoModule()),
    ];
  }
}

/// Exemplo de como integrar no AppModule principal:
///
/// class AppModule extends Module {
///   @override
///   List<Bind> get binds => [
///     // Seus outros binds...
///     ...GtsHistoricoModuleConfig.getBinds(),
///   ];
///
///   @override
///   List<ModularRoute> get routes => [
///     // Suas outras rotas...
///     ...GtsHistoricoModuleConfig.getRoutes(),
///
///     // Ou diretamente:
///     ModuleRoute('/gts-historico', module: GtsHistoricoModule()),
///   ];
/// }

