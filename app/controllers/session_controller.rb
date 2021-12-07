class SessionController < ApplicationController
  def create
    masked_token = create_params[:message].strip.split.last
    unless valid_authenticity_token?(session, masked_token)
      raise "Invalid message"
    end

    public_key = Eth::Key.personal_recover(create_params[:message], create_params[:signature])
    raise "Bad message signature" unless public_key

    address = Eth::Utils.public_key_to_address(public_key)
    session[:wallet] = address

    render json: {address: address}
  end

  private

  def create_params
    params.permit(:message, :signature)
  end
end