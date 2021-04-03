import 'package:flutter/material.dart';
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
          return ParkingInfo(
            carParkID: 'HE45',
            currentAvailable: 245,
            distanceFromCurrent: '1.1 km',
            routeTimeFromCurrent: '22 minutes',
            predictions: [179],
            parkingName: 'BLK 270/271 ALBERT CENTRE BASEMENT CAR PARK',
            parkingType: 'Basement Car Park',
            gantryHeight: 4.5,
            freeParking:
                'All day on Sunday and public holidays, and Friday between 7AM - 10:30PM',
            shortTermParking: 'Available for the whole day',
            nightParking: 'Yes',
            parkingSystem: 'Electronic',
            lat: 1.01,
            lng: 30,
          );
        }
        // displays a circular progress
        return ParkingInfo.isLoading();
      },
    );
  }
}
