class ApplicationController < ActionController::Base
  before_action :load_all_collections
  before_action :check_login

  def load_all_collections
    @all_collections = Collection.all.order(name: :asc)
  end

  def check_login
    if cookies[:wallet].present? and cookies[:wallet] != 'undefined'
      @wallet = Wallet.find_or_create_by(address: cookies[:wallet])
    else
      @wallet = nil
    end
  end

end
