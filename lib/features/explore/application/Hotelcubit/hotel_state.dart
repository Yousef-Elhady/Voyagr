part of 'hotel_cubit.dart';

sealed class HotelState {}

class HotelInitial extends HotelState {} 

final class HotelLoading extends HotelState {}

final class HotelLoaded extends HotelState {
  final List<HotelModel> hotelList;

  HotelLoaded({required this.hotelList});
}

final class HotelErorr extends HotelState {
  final String erorrMessage;
  HotelErorr({required this.erorrMessage});
}
