class TweetsController < ApplicationController
  before_action :logged_in_user, only: [:create]

  def create
    @tweet = current_user.tweets.build(tweet_params)
    if @tweet.save
      flash[:success] = "Tweet created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def destroy
    @tweet = current_user.tweets.find_by(id: params[:id])
    return redirect_to root_url if @tweet.nil?
    @tweet.destroy
    flash[:success] = "ツイートを削除しました"
    redirect_to request.referrer || root_url
  end

  private

  def tweet_params
    params.require(:tweet).permit(:content)
  end
end
