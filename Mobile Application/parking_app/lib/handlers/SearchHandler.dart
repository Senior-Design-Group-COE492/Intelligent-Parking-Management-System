import "package:google_maps_webservice/places.dart";

class SearchHandler {
  static final _googlePlace =
      GoogleMapsPlaces(apiKey: 'AIzaSyDBMJZInXD8H17mj712EHBPalwzIZ-k4oY');

  static Future<List<PlacesSearchResult>> searchPlace(
      String place, String region) async {
    final response = await _googlePlace.searchByText(place, region: region);
    print(response.results.length);
    print(response.results[0].toString());
    return response.results;
  }

  static List<String> generateAddresses(List<PlacesSearchResult> places) {
    final List<String> combinedAddress = [];
    for (final place in places) {
      if (place.formattedAddress == null)
        combinedAddress.add(place.name);
      else
        combinedAddress.add(place.name + ', ' + place.formattedAddress!);
    }
    return combinedAddress;
  }
}
