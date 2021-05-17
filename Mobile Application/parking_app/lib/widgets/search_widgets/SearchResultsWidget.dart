import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_app/controller/MapsController.dart';
import 'package:parking_app/controller/TextFieldController.dart';
import 'package:parking_app/controller/WidgetsController.dart';
import 'package:parking_app/handlers/MarkerHandler.dart';
import 'package:parking_app/handlers/SearchHandler.dart';

class SearchWidget extends StatelessWidget {
  final Future<List<dynamic>>? placesFuture;
  final FieldController? fieldController = Get.put(FieldController());

  SearchWidget({Key? key, this.placesFuture}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: placesFuture,
        builder: (context, dynamic snapshot) {
          print(snapshot.error.runtimeType);
          if (snapshot.hasError) {
            String errorText = '';
            if (snapshot.error.runtimeType.toString() == 'RangeError')
              errorText = 'No locations were found!';
            if (snapshot.error.runtimeType.toString() == 'SocketException')
              errorText = 'Please make sure you are connected to the internet!';
            else
              errorText = 'Something went wrong! Please try again later.';
            return Container(
                padding: EdgeInsets.only(top: 16),
                alignment: Alignment.center,
                child: Text(
                  errorText,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ));
          }
          if (snapshot.hasData) {
            final addresses = SearchHandler.generateAddresses(snapshot.data);
            return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Divider(
                      thickness: 1,
                      color: Colors.grey[200],
                      indent: 16,
                      endIndent: 16,
                    ),
                    TextButton(
                      child: Text(addresses[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black)),
                      onPressed: () async {
                        final lat =
                            snapshot.data[index]['geometry']['location']['lat'];
                        final lng =
                            snapshot.data[index]['geometry']['location']['lng'];
                        MapsController.to.setDestinationLocation(lat, lng);
                        MapsController.to.moveMapCamera(lat, lng, 16);

                        final destinationMarker =
                            await MarkerHandler.makeDestinationMarker(
                                lat, lng, context);
                        WidgetsController.to.setIsLoading(true);
                        final filteredParkings =
                            await SearchHandler.searchParkings();
                        await MarkerHandler.setMarkersFromFilterAndDestination(
                            context, filteredParkings, destinationMarker);

                        fieldController!.isSearching.value = false;
                        fieldController!.isExpanded.toggle();

                        await MarkerHandler.addDestinationMarker(
                            lat, lng, context);
                        WidgetsController.to.setIsLoading(false);
                      },
                    ),
                  ],
                );
              },
            );
          }
          return Container(
              padding: EdgeInsets.only(top: 16),
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
              ));
        });
  }
}
