import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../core/ui/redesign/theme/app_colors.dart';
import '../../../core/ui/redesign/widgets/pdsa_scaffold.dart';
import '../../../core/ui/widgets/app_bar/pdsa_header_bar.dart';
import '../../../core/ui/widgets/offline/sync_button.dart';
import '../../../core/utils/functions.dart';
import '../cidadao_drawer.dart';
import 'gts_module_controller.dart';

class GtsModulePage extends StatefulWidget {
  const GtsModulePage({super.key});

  @override
  State<GtsModulePage> createState() => _GtsModulePageState();
}

class _GtsModulePageState extends State<GtsModulePage> {
  final controller = Modular.get<GtsModuleController>();

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    controller.prefetch();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => PdsaScaffold(
        header: PdsaHeaderBar(
          title: controller.empresa?.nomeFantasia ?? 'GTS',
          settings: const PdsaHeaderSettings(
            collapsible: false,
            showLogo: false,
            alignment: MainAxisAlignment.center,
          ),
          actions: const [],
        ),
        drawer: const CidadaoDrawer(
          indexSelected: 1,
        ),
        body: Column(
          children: [
            const Expanded(child: RouterOutlet()),
            if (controller.backgroundTask != null)
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 16,
                  children: [
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                    Text(Functions.stripMargin(
                      """
                      Realizando tarefas em segundo plano:
                      ${controller.backgroundTask}
                      """,
                    )),
                  ],
                ),
              ),
          ],
        ),
        fab: const SyncButton(),
      ),
    );
  }
}
