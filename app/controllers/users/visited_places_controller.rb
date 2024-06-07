class Users::VisitedPlacesController < Users::ApplicationController

  def index
    @places = current_user.places.only_today.default_order
  end

  def create
    @place = Place.find(params[:id])
    current_user.visited_places.create!(place_id: @place.id)
  end
end
