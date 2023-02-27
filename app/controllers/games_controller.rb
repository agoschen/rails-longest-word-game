require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = [*('A'..'Z')].sample(10)
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    if grid_validity?(@word, @letters) == false
      @answer = "Sorry, but #{@word} can't be built out of #{@letters}"
    elsif english_validity?(@word) == false
      @answer = "Sorry, but #{@word} is not a valid english word!"
    else
      @answer = "Congratulations, #{@word} is a valid english word!"
    end
  end
end

private

def grid_validity?(word, letters)
  word_letters = word.upcase.chars
  word_letters.all? do |letter|
    letters.include?(letter)
  end
end

def english_validity?(word)
  url = "https://wagon-dictionary.herokuapp.com/#{word}"
  word_serialized = URI.open(url).read
  response = JSON.parse(word_serialized)
  response['found']
end


# We want to handle three scenarios:

# The word can’t be built out of the original grid
# The word is valid according to the grid, but is not a valid English word
# The word is valid according to the grid and is an English word
