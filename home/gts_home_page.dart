import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/ui/redesign/widgets/buttons/pdsa_button.dart';
import '../../../../core/ui/redesign/widgets/buttons/pdsa_category_button.dart';
import '../../../../core/utils/vinculo_guard.dart';
import 'gts_home_controller.dart';

class GtsHomePage extends StatefulWidget {
  const GtsHomePage({super.key});

  @override
  State<GtsHomePage> createState() => _GtsHomePageState();
}

class _GtsHomePageState extends State<GtsHomePage> {
  final controller = Modular.get<GtsHomeController>();

  late final List<PdsaCategoryPage> pages;

  @override
  void initState() {
    super.initState();

    pages = [
      PdsaCategoryPage.icon(
        "Emissão GTS",
        "./emissao",
        Icons.people_outlined,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: pages.length,
        itemBuilder: (_, int index) {
          bool selected = controller.selectedPage?.path == pages[index].path;
          PdsaCategoryPage page = pages[index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: PdsaCategoryButton(
              label: page.title,
              icon: page.icon,
              active: selected,
              onPressed: () {
                setState(() {
                  controller.setSelectedPage(selected ? null : pages[index]);
                });
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.all(24),
        elevation: 0,
        child: Observer(
          builder: (_) => PdsaButton.primary(
            "Acessar",
            disabled: controller.selectedPage == null,
            size: Size.LARGE,
            onPressed: () {
              Modular.to.pushNamed(controller.selectedPage!.path);

              setState(() {
                controller.setSelectedPage(null);
              });
            },
          ),
        ),
      ),
    );
  }
}
