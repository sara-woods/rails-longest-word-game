class GamesController < ApplicationController

  def new
    @letters = []
    10.times do
      letter = ("A".."Z").to_a.sample
      @letters << letter
    end
  end

  def score
    @answer = params[:answer].upcase.strip
    grid = params[:grid]
    @grid_array = JSON.parse(grid)

    part_of_grid = part_of_grid?(@answer, @grid_array)
    en_word = valid_english_word?(@answer)

    
    if @answer == ""
      reset_session
      return @reply = 4
    elsif !part_of_grid
      reset_session
      return @reply = 1
    elsif part_of_grid && !en_word
      reset_session
      return @reply = 2
    else
      points = @answer.length
      if session[:points] == nil
        session[:points] = points
        @points = session[:points]
      else
        session[:points] += points
        @points = session[:points]
      end 
      return @reply = 3
    end
  end

  def part_of_grid?(word, grid)
    
    word_array = word.chars
    word_array.each do |letter|

      if grid.include?(letter)
        index = grid.index(letter)
        grid.delete_at(index)
      else
        return false
      end
    end
    return true
  end

  def valid_english_word?(word)
    require 'open-uri'
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    json_string = open(url).read
    JSON.parse(json_string)["found"]
  end
end
