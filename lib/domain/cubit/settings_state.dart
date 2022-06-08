part of 'settings_cubit.dart';

enum IndexPage { categories, home, goals }

abstract class SettingsState extends Equatable {
  final int cats;
  final IndexPage indexPage;

  const SettingsState(this.cats, this.indexPage);
}

class SettingsInitial extends SettingsState {
  SettingsInitial({required int cats, required IndexPage indexPage})
      : super(cats, indexPage);

  @override
  List<Object> get props => [cats, indexPage];
}

class SettingsChangedPage extends SettingsState {
  SettingsChangedPage({required int cats, required IndexPage indexPage})
      : super(cats, indexPage);

  @override
  List<Object> get props => [cats, indexPage];
}

class SettingsAddedCat extends SettingsState {
  SettingsAddedCat({required int cats, required IndexPage indexPage})
      : super(cats, indexPage);

  @override
  List<Object> get props => [cats, indexPage];
}

class SettingsEditedCat extends SettingsState {
  SettingsEditedCat({required int cats, required IndexPage indexPage})
      : super(cats, indexPage);

  @override
  List<Object> get props => [cats, indexPage];
}
