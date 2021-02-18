import "package:google_maps_webservice/places.dart";

class SearchHandler {
  static final googlePlace =
      GoogleMapsPlaces(apiKey: 'AIzaSyDBMJZInXD8H17mj712EHBPalwzIZ-k4oY');

  static Future<List<PlacesSearchResult>> searchPlace(String place) async {
    final result = await googlePlace.searchByText(place, region: "SG");
    print(result.results.length);
    print(result.results[0].formattedAddress);
    return result.results;
  }

  //static List<String> generatePlaceAddress
}
