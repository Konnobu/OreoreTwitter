class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @tweet = current_user.tweets.build
      @feed_items = current_user.feed_items.includes(:user).order(created_at: :desc)
    end
  end
end
