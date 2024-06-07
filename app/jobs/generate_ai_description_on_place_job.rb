class GenerateAiDescriptionOnPlaceJob < ApplicationJob
  queue_as :default

  def perform(place_id:)
    place =  Place.find_by(id: place_id)
    return if place.blank?

    place.update_ai_description!
    Turbo::StreamsChannel.broadcast_replace_to "place_#{place.id}", target: "ai-description-#{place.id}", partial: "places/ai_description", locals: { place: }
  end
end
