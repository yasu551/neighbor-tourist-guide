import { Controller } from "@hotwired/stimulus"
import { Loader } from "@googlemaps/js-api-loader";

// Connects to data-controller="google-map"
export default class extends Controller {
  static values = { apiKey: String }

  initialize() {
    this.loader = new Loader({ apiKey: this.apiKeyValue, version: "weekly" })

    navigator.geolocation.getCurrentPosition((geolocationPosition) => {
      this.position = { lat: geolocationPosition.coords.latitude, lng: geolocationPosition.coords.longitude }
    }, () => {
      this.position = { lat: 0, lng: 0 }
    })
  }

  connect() {
    this.loader.load().then(async () => {
      const { Map } = await google.maps.importLibrary('maps');
      new Map(this.element, {
        center: this.position,
        zoom: 8,
      })
    })
  }
}
