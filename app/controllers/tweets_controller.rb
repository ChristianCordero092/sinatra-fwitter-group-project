class TweetsController < ApplicationController
    
    get '/tweets' do
        if logged_in?
            @tweets = Tweet.all
            erb :'tweets/tweets'
        else
            redirect to :'/login'
        end
    end

    get '/tweets/new' do
        if logged_in?
            erb :'tweets/new_tweet'
        else
            redirect to :'/login'
        end
    end

    post '/tweets' do
        if logged_in?
            if params[:content].empty?
                redirect to :"/tweets/new"
            else
                @tweet = current_user.tweets.build(content: params[:content])
                if @tweet.save
                    redirect to :"/tweets"
                else
                    redirect to :"/tweets/new"
                end
            end
        else
            redirect to :'/login'
        end
    end

    get '/tweets/:id' do 
        if logged_in?
            @tweet = Tweet.find_by_id(params[:id])
            erb :'/tweets'
        else
            redirect to :'/login'
        end
    end

    patch '/tweets/:id' do
        @tweet = Tweet.find_by_id(params[:id])
        if !params[:content].empty?
            @tweet.update(content: params[:content])
            @tweet.save
            redirect to :'/tweets/#{params[:id]}'
        else
            redirect to :'/tweets/#{params[:id]}/edit'
        end
    end

    post '/tweets/:id/delete' do 
        @tweet = Tweet.find_by_id(params[:id])
        if @tweet.user == current_user
            @tweet.delete
            redirect to :'/tweets'
        else
            redirect to :'/tweets'
        end
    end
end