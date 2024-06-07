class Place < ApplicationRecord
  class << self

    def create_or_find_by_from_google_place!(uuid:)
      place = find_by(uuid:)
      return place if place.present?

      create_from_google_place!(uuid:)
    end
  end

  def to_param
    uuid
  end

  private

  class << self
    def create_from_google_place!(uuid:)
      conn = Faraday.new(
        url: "https://places.googleapis.com/v1/places",
        params: { languageCode: 'ja' },
        headers: {
          'Content-Type' => 'application/json',
          'X-Goog-Api-Key' => Rails.application.credentials.google.api_key,
          'X-Goog-FieldMask' => 'id,displayName,editorialSummary,location,photos'
        }
      ) do |f|
        f.response :json
      end
      body = conn.get(uuid).body
      location = body['location']
      photo = body['photos'].first
      create!(uuid: body['id'],
          name: body['displayName']['text'],
          description: body['editorialSummary']['text'],
          latitude: location['latitude'],
          longitude: location['longitude'],
          photo_url: format_photo_url(photo_name: photo['name']))
    end

    def format_photo_url(photo_name:)
      key = Rails.application.credentials.google.api_key
      max_width_px = 400
      max_height_px = 400
      "https://places.googleapis.com/v1/#{photo_name}/media?key=#{key}&maxWidthPx=#{max_width_px}&maxHeightPx=#{max_height_px}"
    end
  end
end
