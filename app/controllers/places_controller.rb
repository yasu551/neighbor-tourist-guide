class PlacesController < ApplicationController
  before_action :set_place, only: %i[show]

  def show
  end

  private

  def set_place
    @place = Place.create_or_find_by_from_google_place!(uuid: params[:uuid])
  end

  def place_params
    params.require(:place)
  end
end
