import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../core/ui/global/global_snack_bar.dart';
import '../../../core/ui/global/ihc.dart';
import '../../../core/ui/redesign/widgets/buttons/pdsa_button2.dart';
import '../../../core/ui/theme/app_colors.dart';
import '../../../core/utils/conectividade.dart';
import '../../../core/cache/cache_usuario.dart';
import '../../shared/login/model/empresa_model.dart';
import '../../shared/login/model/usuario_model.dart';
import '../../shared/login/service/empresa_service.dart';
import '../../shared/login/service/login_service.dart';
import '../../shared/login/service/usuario_service.dart';
import 'gts_module_controller.dart';

class GtsSelecionarVinculoPage extends StatefulWidget {
  const GtsSelecionarVinculoPage({super.key});

  @override
  State<GtsSelecionarVinculoPage> createState() => _GtsSelecionarVinculoPageState();
}

class _GtsSelecionarVinculoPageState extends State<GtsSelecionarVinculoPage> {
  final controller = Modular.get<GtsModuleController>();
  final loginService = Modular.get<LoginService>();
  EmpresaModel? temp;

  @override
  void initState() {
    controller.processing = true;
    checkQuantidadeEmpresas();
    super.initState();
  }

  void checkQuantidadeEmpresas() async {
    bool isOnline = await Conectividade.isOnline();
    if (isOnline) {
      await controller.fetchEmpresasbyUser();
      if (controller.empresas.length == 1) {
        await selecionaEmpresa(controller.empresas[0]);
      } else {
        controller.processing = false;
      }

      CacheUsuario.fromUsuario(loginService.usuarioLogado!).updateUsuarioCache();
    } else {
      UsuarioModel usuario = loginService.usuarioLogado!;

      if (usuario.empresa != null) {
        controller.setEmpresa(usuario.empresa);
      } else {
        GlobalSnackBar.i.showSnackBar("Você precisa estar online para selecionar uma empresa.", color: Colors.red);
        Modular.to.pushNamedAndRemoveUntil('./selecionar-vinculo', (p0) => false);
      }
      controller.processing = false;

      Modular.to.pushNamedAndRemoveUntil('./guias/', (p0) => false);
    }
  }

  Future<void> selecionaEmpresa(EmpresaModel empresa) async {
    IHC.requiresInternet(() async {
      controller.processing = true;
      int? idUsuario = loginService.usuarioLogado?.id;
      if (idUsuario != null) {
        var aux = await UsuarioService().updateEmpresaPrincipal(idUsuario, empresa.id);
        if (aux) {
          bool atualizou = await loginService.updateTokenWithRefreshToken(1);
          if (!atualizou) {
            await loginService.updateTokenWithRefreshToken(2);
          }

          empresa = await EmpresaService().getEmpresaByUuid(empresa.uuid);
          loginService.usuarioLogado?.empresa = empresa;

          var usr = await CacheUsuario.get();
          if (usr != null) {
            usr.empresa = empresa;
            usr.updateUsuarioCache();
          }

          controller.setEmpresa(empresa);

          Modular.to.pushNamedAndRemoveUntil('./guias/', (p0) => false);
        } else {
          GlobalSnackBar.i.showSnackBar("Houve um erro, tente novamente!", color: Colors.red);
          controller.processing = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Scaffold(
            backgroundColor: Colors.white,
            body: Observer(builder: (_) {
              if (controller.loading || controller.processing || controller.empresas.length == 1) {
                return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ));
              }
              if (controller.empresas.isEmpty) {
                return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Nenhum módulo habilitado para o seu usuário possui disponibilidade para esta versão do aplicativo.",
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      )),
                  PDSAButton2(
                    title: "Logout",
                    cor: tiposCores.secondary,
                    onPressed: () async {
                      await loginService.logout();
                      Modular.to.pushNamedAndRemoveUntil('/shared/login', (p0) => false);
                    },
                  )
                ]);
              }
              return ListView.separated(
                  itemCount: controller.empresas.length,
                  itemBuilder: ((context, index) => ListTile(
                    title: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      Text(
                        controller.empresas[index].nomeFantasia,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(children: [
                        Expanded(
                            child: AutoSizeText(
                              (controller.empresas[index].permissoesUsuario ?? []).join(", ").toUpperCase().contains("REPRESENTANTE")
                                  ? "REPRESENTANTE"
                                  : (controller.empresas[index].permissoesUsuario ?? []).join(", ").toUpperCase(),
                              textAlign: TextAlign.start,
                              maxFontSize: 13,
                              maxLines: 2,
                            )),
                      ]),
                    ]),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                      if (controller.loading || controller.processing) {
                        return;
                      }
                      selecionaEmpresa(controller.empresas[index]);
                    },
                  )),
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      thickness: 0.8,
                    );
                  });
            }));
      },
    );
  }
}
