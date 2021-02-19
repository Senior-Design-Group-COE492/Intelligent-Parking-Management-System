class MapsGlobals {
  // stupidly long strings aka. I'm lazy
  static const String style =
      '[{"elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#ffeb3b"}]},{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},{"featureType":"administrative.neighborhood","stylers":[{"visibility":"off"}]},{"featureType":"landscape.man_made","elementType":"geometry","stylers":[{"color":"#f7f7f7"}]},{"featureType":"poi.medical","elementType":"geometry","stylers":[{"color":"#f7f7f7"}]},{"featureType":"road","stylers":[{"visibility":"on"}]},{"featureType":"transit","stylers":[{"visibility":"on"}]},{"featureType":"transit","elementType":"labels","stylers":[{"visibility":"on"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#bde1f1"}]}]';
  static const String flagSvg =
      '<svg xmlns="http://www.w3.org/2000/svg" height="24" viewBox="0 0 24 24" width="24"><path d="M0 0h24v24H0z" fill="none"/><path d="M14.4 6L14 4H5v17h2v-7h5.6l.4 2h7V6z"/></svg>';
  // builds the svg string with the appropriate number of  available parking spaces
  static String makeMapMarkerSvg(int nAvailableParkingSpaces) {
    final String fillColor =
        nAvailableParkingSpaces >= 8 ? '#7ACAFF' : '#FF848F';
    return '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="30" height="25" viewBox="0 0 30 25"> <g transform="matrix(1, 0, 0, 1, 0, 0)" filter="url(#svg_5)"> <path id="svg_5-2" data-name="svg_5" d="M4,0H17.211a4,4,0,0,1,4,4V9.705a4,4,0,0,1-4,4H12.063l-1.036,2.67-1.182-2.67H4a4,4,0,0,1-4-4V4A4,4,0,0,1,4,0Z" fill="$fillColor"/> </g> <text id="_245" data-name="245" font-size="8" font-family="Roboto-Regular, Roboto" x="10.5" y="10" dominant-baseline="middle" text-anchor="middle">$nAvailableParkingSpaces</text> </svg> ';
  }
}
