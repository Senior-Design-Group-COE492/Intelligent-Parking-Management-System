import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parking_app/handlers/FirestoreHandler.dart';
import 'package:parking_app/handlers/LoginHandler.dart';
import 'package:parking_app/widgets/favorites_widgets/FavoritedParkingInfoWidget.dart';

class FavoritesList extends StatelessWidget {
  FavoritesList() {
    // initializes the user info before getting the stream
  }

  @override
  Widget build(BuildContext context) {
    final indicator = Align(
      child: Container(
        child: CircularProgressIndicator(strokeWidth: 2.5),
        height: 30,
        width: 30,
      ),
    );

    return FutureBuilder(
        future: FirestoreHandler.getUserInformationStream(
            LoginHandler.getCurrentUserID()!),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return StreamBuilder(
              stream: snapshot.data,
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return indicator;
                }
                final favoritesList = snapshot.data?.data()?['favorites'];
                return Container(
                  padding: EdgeInsets.only(left: 15, top: 0),
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 16),
                    shrinkWrap: true,
                    itemCount: favoritesList.length,
                    itemBuilder: (context, index) {
                      final double padding =
                          (index == favoritesList.length - 1) ? 90 : 10;
                      final favoriteWidget = FavoritedParkingInfo(
                        carParkID: favoritesList[index],
                        currentAvailable: '123',
                        lat: 1.01,
                        lng: 1.02,
                        parkingName:
                            'BLK 270/271 ALBERT CENTRE BASEMENT CAR PARK',
                        parkingType: 'Basement Car Park',
                        predictions: [30],
                      );
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: favoriteWidget),
                              IconButton(
                                icon: Icon(Icons.delete_forever),
                                onPressed: () => {
                                  FirestoreHandler.removeFavorite(
                                      favoritesList[index]),
                                },
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: padding),
                          )
                        ],
                      );
                    },
                  ),
                );
              },
            );
          }
          if (snapshot.hasError) {
            Text('Something went wrong!');
          }
          return indicator;
        });
  }
}
