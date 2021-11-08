require 'open-uri'

class GamesController < ApplicationController
  def new
    @username = params[:user_name]
    @letters = []
    9.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    @letters_array = params[:letters].split
    @user_answer = params[:user_input].upcase
    @score = 0
    if !letters_valid?(@user_answer, @letters_array)
      @text = 'Incorrect use of the letters'
    elsif !word_exists?(@user_answer)
      @text = 'This word does not exist'
    else
      @text = 'Well done, your word exists'
      @score = @user_answer.length
    end
    @high_scores = session[:scores] || []
    @high_scores << { 'score' => @score, 'name' => params[:username].upcase == '' ? 'USER' : params[:username].upcase }
    session[:scores] = @high_scores
  end

  private

  def word_exists?(word)
    data = URI.open("https://wagon-dictionary.herokuapp.com/#{word}").read
    JSON.parse(data)['found']
  end

  def letters_valid?(word, letters_array)
    word.chars.all? do |letter|
      letters_array.include?(letter) && word.count(letter) <= letters_array.count(letter)
    end
  end
end
