import 'package:flutter/material.dart';
import 'package:parking_app/handlers/MarkerHandler.dart';
import 'package:parking_app/widgets/maps_widgets/ParkingInfoWidget.dart';

class ParkingInfoFromFuture extends StatelessWidget {
  // returns the ParkingInfo widget and constructs it after reading
  // the parking info from Firestore
  final String parkingId;
  ParkingInfoFromFuture({Key? key, required this.parkingId})
      // TODO: replace future delay with a reading from Firestore
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // TODO: modify future to read from Firestore instead
      future: Future.delayed(Duration(seconds: 2), () => 5),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        }
        if (snapshot.hasData) {
          final carPark = MarkerHandler.parkingLots![parkingId];
          return ParkingInfo(
            carParkID: parkingId,
            currentAvailable: 245,
            distanceFromCurrent: '1.1 km',
            routeTimeFromCurrent: '22 minutes',
            predictions: [179],
            parkingName: carPark['address'],
            parkingType: carPark['car_park_type'],
            gantryHeight: carPark['gantry_height'],
            freeParking: carPark['free_parking'],
            shortTermParking: carPark['short_term_parking'],
            nightParking: carPark['night_parking'],
            parkingSystem: carPark['type_of_parking_system'],
            lat: carPark['lat'],
            lng: carPark['lng'],
          );
        }
        // displays a circular progress
        return ParkingInfo.isLoading();
      },
    );
  }
}
