import 'package:ai_travel/features/explore/data/hotelreopsitry.dart';
import 'package:ai_travel/features/explore/domain/hotelmodel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'hotel_state.dart';

class HotelCubit extends Cubit<HotelState> {
  final Hotelreopsitry _hotelreopsitry;
  HotelCubit({required Hotelreopsitry hotelreopsitry})
    : _hotelreopsitry = hotelreopsitry,
      super(HotelInitial());
  void getAllhottel({required String city}) async {
    emit(HotelLoading());
    try {
      final List<HotelModel> hotelList = await _hotelreopsitry
          .getAllDestination(city: city);
      emit(HotelLoaded(hotelList: hotelList));
    } catch (e) {
      emit(HotelErorr(erorrMessage: e.toString()));
    }
  }
}
