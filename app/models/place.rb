class Place < ApplicationRecord
  after_create_commit do
    GenerateAiDescriptionOnPlaceJob.perform_later(place_id: id)
  end

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

  def update_ai_description!
    client = OpenAI::Client.new
    messages = [
      { role: "system", content: "assistantは旅行ガイドであり、userは旅行者です。assistantはmarkdown記法を使わず、話し言葉のような文章を返します。" },
      { role: "assistant", content: "了解しました！どの国または都市についての情報をお知りになりたいですか？また、どのようなアクティビティに興味がありますか？例えば、文化的な観光、食事、自然の探索などがあります。" },
      { role: "user", content: "#{name}について説明してください。" }
    ]
    response = client.chat(
      parameters: {
        model: "gpt-4o",
        messages:
      }
    )
    update!(ai_description: response.dig("choices", 0, "message", "content"))
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
          description: body.dig('editorialSummary', 'text') || '',
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
