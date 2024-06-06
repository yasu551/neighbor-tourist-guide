import { Controller } from "@hotwired/stimulus"
import { Loader } from "@googlemaps/js-api-loader";

// Connects to data-controller="google-map"
export default class extends Controller {
  static values = { apiKey: String, mapId: String }

  initialize() {
    this.loader = new Loader({ apiKey: this.apiKeyValue, version: "weekly" })
  }

  async connect() {
    await navigator.geolocation.getCurrentPosition((geolocationPosition) => {
      this.position = { lat: geolocationPosition.coords.latitude, lng: geolocationPosition.coords.longitude }
    }, () => {
      this.position = { lat: 0, lng: 0 }
    })

    await this.loader.load().then(async () => {
      const { Map } = await google.maps.importLibrary('maps');
      const { PinElement, AdvancedMarkerElement } = await google.maps.importLibrary("marker");

      this.map = new Map(this.element, {
        center: this.position,
        zoom: 15,
        mapId: this.mapIdValue
      })

      const currentPositionPin = new PinElement({
        background: '#00008B',
        glyphColor: '#87CEEB',
        borderColor: '#87CEEB',
      });

      const marker = new AdvancedMarkerElement({
        map: this.map,
        position: this.position,
        title: "CurrentPosition",
        content: currentPositionPin.element,
      });
    })

    this.loader.load().then(async () => {
      const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");
      const { places } = await this.fetchNearPlaces();
      this.places = await places;
      for (const place of this.places) {
        const advancedMarkerElement = new AdvancedMarkerElement({
          map: this.map,
          position: { lat: place.location.latitude, lng: place.location.longitude },
          title: place.displayName.text,
        });
      }
    });
  }

  fetchNearPlaces() {
    const url = 'https://places.googleapis.com/v1/places:searchNearby';
    const headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': this.apiKeyValue,
      'X-Goog-FieldMask': 'places.id,places.location,places.displayName',
    }
    const method = 'POST';
    const data =
        {
          "includedTypes": ['restaurant'],
          "locationRestriction": {
            "circle": {
              "center": {
                "latitude": this.position.lat,
                "longitude": this.position.lng,
              },
              "radius": 1000.0
            }
          }
        };
    const body = JSON.stringify(data);
    const options = { headers, method, body };
    return fetch(url, options)
            .then(response => response.json());
  }
}
