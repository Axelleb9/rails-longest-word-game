require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid(10)
  end

  def score
    @attempt = params[:attempt]
    @letters = params[:grid]
    @message = message(@attempt, @letters)
  end

  private

  def generate_grid(grid_size)
    alphabet = ('A'..'Z').to_a
    grid_size.times.map { alphabet.sample }
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    json = open(url).read
    user = JSON.parse(json)
    user['found']
  end

  def not_in_the_grid?(attempt, grid)
    word = attempt.split('')
    test = word.map do |letter|
      word.count(letter) <= grid.split(' ').count(letter)
    end
    test.include?(false)
  end

  def message(attempt, grid)
    if !not_in_the_grid?(attempt.upcase, grid)
      if english_word?(attempt)
        @text = "Congratulations! #{attempt} is a valid English word!"
      else
        @text = "Sorry but #{attempt} does not seem to be valid English word..."
      end
    else
      @text = "Sorry but #{attempt} can't be built out of #{grid}"
    end
  end
end
