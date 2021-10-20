class ApplicationController < ActionController::Base
  before_action :load_all_collections

  def load_all_collections
      @all_collections = Collection.all.order(name: :asc)
  end

end
