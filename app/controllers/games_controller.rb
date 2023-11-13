require 'net/http'
require 'json'

class GamesController < ApplicationController
  Rails.application.config.session_store :cache_store

  def new
    @start_time = Time.new
    @letters = []
    12.times do
      @letters.push(('A'..'Z').to_a.sample )
    end
  end


  def score
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    response = JSON.parse(response)
    split_array = params[:word].upcase.chars
    start_time = params[:start_time].to_datetime
    end_time = Time.new
    elapsed_time = end_time - start_time
    if response['found']
      if split_array.all? { |char| params[:letters].split(' ').count(char) >= split_array.count(char) }
        @message = "Congratulations! [#{params[:word]}] is a valid english word."
        @score = params[:word].length.to_f / elapsed_time
      else
        @message = "Sorry but [#{params[:word]}] isn't built out of |#{params[:letters].split(' ').join(", ")}|"
        @score = 0
      end
    else
      @message = "Sorry but [#{params[:word]}] doesn't seem to be a valid english word"
      @score = 0
    end
  end
end
