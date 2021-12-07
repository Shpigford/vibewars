class ApplicationController < ActionController::Base
  before_action :load_all_collections
  before_action :current_wallet

  def current_wallet
    return unless session[:wallet]
    @current_wallet ||= Wallet.find_or_create_by(address: session[:wallet])
  end

  def load_all_collections
    @all_collections = Collection.all.order(name: :asc)
  end

  # before_action :check_login
  # def check_login
  #   if cookies[:wallet].present? and cookies[:wallet] != 'undefined'
  #     @wallet = Wallet.find_or_create_by(address: cookies[:wallet])
  #   else
  #     @wallet = nil
  #   end
  # end

end
