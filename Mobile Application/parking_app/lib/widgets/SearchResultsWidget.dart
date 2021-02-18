import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:parking_app/handlers/SearchHandler.dart';

class SearchWidget extends StatelessWidget {
  final Future<List<PlacesSearchResult>> placesFuture;

  const SearchWidget({Key key, this.placesFuture}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: placesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Container(
                padding: EdgeInsets.only(top: 16),
                alignment: Alignment.center,
                child: Text(
                  'No locations were found!',
                  style: TextStyle(color: Colors.grey),
                ));
          }
          if (snapshot.hasData) {
            final addresses = SearchHandler.generateAddresses(snapshot.data);
            return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data.length,
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
                      onPressed: () {
                        // TODO: send request to server with filter info
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
              child: CircularProgressIndicator());
        });
  }
}
