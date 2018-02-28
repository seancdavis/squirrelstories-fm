class UtilitiesController < ApplicationController

  def bust_cache
    Rails.cache.delete_matched(/^views\/(.*)/)
    head :ok
  end

end
