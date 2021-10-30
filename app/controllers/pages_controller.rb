class PagesController < ApplicationController
  def search
    @collections = Collection.where(
      "name ILIKE :search OR description ILIKE :search OR symbol ILIKE :search", search: "%#{params[:term]}%"
    )
  end
end
