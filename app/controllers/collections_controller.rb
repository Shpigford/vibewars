class CollectionsController < ApplicationController
  before_action :get_collection, except: [:index]

  def index
    @collections = Collection.all.order(name: :asc)

    respond_to do |format|
      format.html
      format.json { render json: { collections: @collections } }
    end
  end

  def show
    compare = @collection.assets.left_outer_joins(:ranking).where.not(image_url: nil).order(Arel.sql("(1 - (rankings.votes_count :: DECIMAL / MAX((rankings.votes_count+1) * 100) OVER())) * (floor(random() * 40 + 1) :: int) desc")).limit(25)

    if compare.size < 10
      compare = @collection.assets.left_outer_joins(:ranking).where.not(image_url: nil).order(Arel.sql("(1 - (rankings.votes_count :: DECIMAL / MAX((rankings.votes_count+1) * 100) OVER())) * (floor(random() * 40 + 1) :: int) desc")).limit(50)
    end

    @item_first = compare.sample
    @item_last = compare.sample
    @next_first = compare.sample
    @next_last = compare.sample

    if @current_wallet.present?
      @recent_vote_count = @collection.votes.where('wallet_id = ? AND created_at > ?', @current_wallet.id, Time.current - 60.minutes).count
    else
      @recent_vote_count = @collection.votes.where('ip_address = ? AND created_at > ?', request.remote_ip, Time.current - 60.minutes).count
    end

    @vote_throttle = @recent_vote_count > 300 ? true : false
    
    respond_to do |format|
      format.html
      format.json { render json: { collection: @collection.attributes.except('traits'), total_items: @collection.assets.count, total_votes: @collection.votes.count, percent_done: @collection.percentage_voted, rank_confidence: @collection.rank_confidence, item_first: @item_first.attributes.except('traits'), item_last: @item_last.attributes.except('traits'), next: {next_first: @next_first.attributes.except('traits'), next_last: @next_last.attributes.except('traits')} } }
    end

    if @item_first == @item_last or @item_first.blank? or @item_last.blank? 
      redirect_to collection_path(@collection.slug)
    end
  end

  def ranking
    @assets = @collection.assets

    if params[:trait].present?
      params[:trait].each do |trait|
        @assets = @assets.left_outer_joins(:ranking).where('traits @> ?', [{trait_type: trait['type']}, {value: trait['value']}].to_json)
      end
    end

    @assets = @assets.left_outer_joins(:ranking).where('rankings.rank > 0').order('rankings.rank ASC').page params[:page]

    respond_to do |format|
      format.html
      format.json { render json: { collection: @collection, total_items: @collection.assets.count, total_votes: @collection.votes.count, percent_done: @collection.percentage_voted, rank_confidence: @collection.rank_confidence, assets: @assets } }
    end
  end

  def leaderboard
    @discord = Discordrb::Bot.new(token: ENV['DISCORD'])

    @leaders = Rails.cache.fetch(["v2","query-leaders-#{@collection.id}"], expires_in: 1.hour) do
      @collection.votes.where("wallet_id IS NOT NULL OR discord_user_id IS NOT NULL").group(:wallet_id, :discord_user_id).order(count_all: :desc).count.first(100)
    end
  end

private
  def get_collection
    if /\A0x[a-fA-F0-9]{40}\z/i.match(params[:id])
      @collection = Collection.where(address: params[:id]).first
      redirect_to ranking_collection_path(@collection.slug)
    else
      @collection = Collection.where(slug: params[:id]).first
    end
  end

end
