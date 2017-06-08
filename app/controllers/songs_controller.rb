require 'rack-flash'
#require 'sinatra/redirect_with_flash'
class SongsController < ApplicationController
  use Rack::Flash

  get '/songs' do
    @songs = Song.all
    erb :'songs/index'
  end

  get '/songs/new' do
    @genres = Genre.all
    erb :'songs/new'
  end

  post '/songs' do
    @song = Song.find_or_create_by(:name => params[:Name])
    @artist = Artist.find_or_create_by(:name => params["Artist Name"])
    @song.artist = @artist
    @song.genre_ids = params[:genres]
    @genres = @song.genres
    
    if @song.save
      session[:message] = "Successfully created song."
    else
      session[:message] = "Song NOT saved!"
    end 
    redirect "/songs/#{@song.slug}"
  end

  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    @artist = @song.artist
    @genres = @song.genres
    flash[:message] = session[:message]
    session[:message] = ""

    erb :'/songs/show'
  end
end
