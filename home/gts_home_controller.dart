import 'package:mobx/mobx.dart';

import '../../../../core/ui/redesign/widgets/buttons/pdsa_category_button.dart';

part 'gts_home_controller.g.dart';

class GtsHomeController = _GtsHomeControllerBase with _$GtsHomeController;

abstract class _GtsHomeControllerBase with Store {
  _GtsHomeControllerBase();

  @observable
  PdsaCategoryPage? selectedPage;

  @action
  setSelectedPage(PdsaCategoryPage? page) => selectedPage = page;
}
