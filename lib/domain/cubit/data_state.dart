part of 'data_cubit.dart';

abstract class DataState extends Equatable {
  final CustomUser customUser;

  const DataState(this.customUser);
}

class DataInitial extends DataState {
  DataInitial({required CustomUser customUser}) : super(customUser);

  @override
  List<Object> get props => [customUser];
}

class DataInitialized extends DataState {
  DataInitialized({required CustomUser customUser}) : super(customUser);

  @override
  List<Object> get props => [customUser];
}

class DataChanged extends DataState {
  DataChanged({required CustomUser customUser}) : super(customUser);

  @override
  List<Object> get props => [customUser];
}
