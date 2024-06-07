import { Controller } from "@hotwired/stimulus"
import { Loader } from "@googlemaps/js-api-loader";
import { get } from '@rails/request.js'

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

    await this.loader.load().then(async () => {
      const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");
      const { places } = await this.fetchNearPlaces();
      for (const place of places) {
        const advancedMarkerElement = new AdvancedMarkerElement({
          map: this.map,
          position: { lat: place.location.latitude, lng: place.location.longitude },
          title: place.displayName.text,
        });
        advancedMarkerElement.addListener('click', (event) => {
          console.log(place);
          const response = get(`http://localhost:3000/places/${place.id}`);
          console.log(response);
        })
      }
    });
  }

  fetchNearPlaces() {
    const url = 'https://places.googleapis.com/v1/places:searchNearby';
    const headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': this.apiKeyValue,
      'X-Goog-FieldMask': 'places.id,places.location,places.displayName,places.editorialSummary',
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
