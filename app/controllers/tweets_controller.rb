class TweetsController < ApplicationController

  get '/tweets' do
		if logged_in?
			@user = current_user
			@tweets = Tweet.all
			erb :'/tweets/tweets'
		else
			redirect '/login'
		end
	end

  get '/tweets/new' do
    if logged_in?
      @tweets = Tweet.all
      erb :'tweets/new'
    else
      redirect '/login'
    end
  end

  get '/tweets/:id' do
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      erb :'tweets/show_tweet'
    else
      redirect '/login'
    end
  end

  post '/tweets' do
    if params[:content] == ''
      redirect to '/tweets/new'
    else
      user = current_user
      tweet = Tweet.create(content: params[:content])
      tweet.user = current_user
      tweet.save
      redirect to "/tweets/#{tweet.id}"
    end
  end

  get '/tweets/:id/edit' do
    @tweet = Tweet.find_by_id(params[:id])
    if logged_in? && current_user.id == @tweet.user.id
      erb :'/tweets/edit_tweet'
    elsif logged_in?
      redirect '/tweets'
    else
      redirect '/login'
    end
  end

  patch '/tweets/:id' do
    @tweet = Tweet.find_by_id(params[:id])
    @tweet.content = params[:content]
    if @tweet.user.id == current_user.id && @tweet.save && !params[:content] == ''
      redirect '/tweets/#{@tweet.id}'
    else
      redirect '/tweets/#{@tweet.id}/edit'
  end
end




end
