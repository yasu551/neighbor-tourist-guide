class Users::VisitedPlacesController < Users::ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    @places = current_user.places.only_today.default_order
  end

  def create
    @place = Place.find(params[:id])
    current_user.visited_places.create!(place_id: @place.id)
  end
end
