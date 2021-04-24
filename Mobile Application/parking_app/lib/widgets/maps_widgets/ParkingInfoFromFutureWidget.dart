import 'package:flutter/material.dart';
import 'package:parking_app/controller/MapsController.dart';
import 'package:parking_app/handlers/FirestoreHandler.dart';
import 'package:parking_app/handlers/MarkerHandler.dart';
import 'package:parking_app/handlers/SearchHandler.dart';
import 'package:parking_app/widgets/maps_widgets/ParkingInfoWidget.dart';

class ParkingInfoFromFuture extends StatelessWidget {
  // returns the ParkingInfo widget and constructs it after reading
  // the parking info from Firestore
  final String parkingId;
  ParkingInfoFromFuture({Key? key, required this.parkingId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final carPark = MarkerHandler.parkingLots![parkingId];

    return FutureBuilder(
      // TODO: modify future to read from Firestore as well
      future: MapsController.to.currentLocation != null
          ? SearchHandler.getRouteTime(MapsController.to.currentLocation!,
              carPark['lat'], carPark['lng'])
          : Future.delayed(Duration(seconds: 1)),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        }
        if (snapshot.hasData) {
          print((snapshot.data! as Map)['status']);
          return ParkingInfo(
            carParkID: parkingId,
            currentAvailableStream: FirestoreHandler.currentAvailStream,
            distanceFromCurrent:
                (snapshot.data! as Map)['status'] != 'ZERO_RESULTS'
                    ? (snapshot.data! as Map)['distance']['text']
                    : 'Enable location to see this.',
            routeTimeFromCurrent:
                (snapshot.data! as Map)['status'] != 'ZERO_RESULTS'
                    ? (snapshot.data! as Map)['duration']['text']
                    : 'Enable location to see this.',
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
