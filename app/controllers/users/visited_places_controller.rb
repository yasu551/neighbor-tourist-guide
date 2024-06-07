class Users::VisitedPlacesController < Users::ApplicationController
  def create
    @place = Place.find(params[:id])
    current_user.visited_places.create!(place_id: @place.id)
  end
end
