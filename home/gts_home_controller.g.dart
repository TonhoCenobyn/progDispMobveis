// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gts_home_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$GtsHomeController on _GtsHomeControllerBase, Store {
  late final _$selectedPageAtom =
  Atom(name: '_GtsHomeControllerBase.selectedPage', context: context);

  @override
  PdsaCategoryPage? get selectedPage {
    _$selectedPageAtom.reportRead();
    return super.selectedPage;
  }

  @override
  set selectedPage(PdsaCategoryPage? value) {
    _$selectedPageAtom.reportWrite(value, super.selectedPage, () {
      super.selectedPage = value;
    });
  }

  late final _$_GtsHomeControllerBaseActionController =
  ActionController(name: '_GtsHomeControllerBase', context: context);

  @override
  dynamic setSelectedPage(PdsaCategoryPage? page) {
    final _$actionInfo = _$_GtsHomeControllerBaseActionController.startAction(
        name: '_GtsHomeControllerBase.setSelectedPage');
    try {
      return super.setSelectedPage(page);
    } finally {
      _$_GtsHomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedPage: ${selectedPage}
    ''';
  }
}
