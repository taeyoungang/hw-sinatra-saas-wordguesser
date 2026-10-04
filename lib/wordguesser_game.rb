class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  attr_accessor :word_with_guesses

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @word_with_guesses = "-" * word.length
  end

  # guess method returns true if the letter guess is valid, otherwise false
  def guess(letter)
    # check empty nil string
    if letter == '' || letter == nil
      raise ArgumentError
    end

    letter = letter.downcase
    if !letter.match?(/[a-z]/)
      raise ArgumentError
    elsif guesses.include?(letter) || wrong_guesses.include?(letter)
      return false
    else
      guess_correct = false
      word.each_char.with_index do |char, idx|
        if char == letter
          guess_correct = true
          word_with_guesses[idx] = letter
        end
      end
      if guess_correct
        guesses << letter
      else
        wrong_guesses << letter
      end
      return true
    end
  end

  def check_win_or_lose
    if wrong_guesses.length > 6
      return :lose
    elsif !word_with_guesses.match?(/[^a-z]/)
      return :win
    else
      return :play
    end
  end

  # Get a word from remote "random word" service

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('https://esaas-randomword-27a759b6224d.herokuapp.com/RandomWord') 
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http| 
      return http.post(uri, "").body
    end
  end
end
