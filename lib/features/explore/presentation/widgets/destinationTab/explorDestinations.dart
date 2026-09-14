import 'package:ai_travel/features/explore/application/cubit/explor_cubit.dart';
import 'package:ai_travel/features/explore/presentation/widgets/destinationTab/destination_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Explordestinations extends StatefulWidget {
  const Explordestinations({super.key});

  @override
  State<Explordestinations> createState() => _ExplordestinationsState();
}

class _ExplordestinationsState extends State<Explordestinations> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExplorCubit()..getDestinations(),
      child: BlocBuilder<ExplorCubit, ExplorState>(
        builder: (context, explorstate) {
          if (explorstate is ExplorLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (explorstate is ExplorLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              itemCount: explorstate.exploredTrips.length,
              itemBuilder: (context, index) => SizedBox(
                height: 220,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: DestinationCard(
                    destination: explorstate.exploredTrips[index],
                  ),
                ),
              ),
            );
          }
          if (explorstate is ExplorError) {
            return Center(child: Text(explorstate.errMsg));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
