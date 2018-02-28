class QuotesController < ApplicationController

  caches_action :index, :show

  def index
    @quotes = Sapwood::QuoteService.get_all.shuffle
  end

  def show
    @quote = Sapwood::QuoteService.get(params[:id])
    @other_quotes = (Sapwood::QuoteService.get_all.shuffle - [@quote]).first(3)
    not_found unless @quote.episode.id.to_s == params[:episode_id].to_s
  end

end
