import 'package:ai_travel/features/explore/data/destination_api.dart';
import 'package:ai_travel/features/explore/data/destination_repository.dart';
import 'package:ai_travel/features/explore/domain/destinationmodel.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'explor_state.dart';

class ExplorCubit extends Cubit<ExplorState> {
  final PlacesRepository _repository = PlacesRepository(
    placesApi: PlacesApi(dio: Dio()),
  );
  ExplorCubit() : super(ExplorLoading());

  Future<void> getDestinations() async {
    emit(ExplorLoading());
    print(" emit(ExplorLoading());");
    try {
      dynamic destinations = await _repository.getAllDestination();
      emit(ExplorLoaded(exploredTrips: destinations));
    } catch (e) {
      emit(ExplorError(errMsg: e.toString()));
    }
  }
}
