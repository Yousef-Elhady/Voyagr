part of 'explor_cubit.dart';

sealed class ExplorState {}

final class ExplorLoading extends ExplorState {}

final class ExplorLoaded extends ExplorState {
  final List<DestinationModel> exploredTrips;

  ExplorLoaded({required this.exploredTrips});
}

final class ExplorError extends ExplorState {
  final String errMsg;

  ExplorError({required this.errMsg});
}
