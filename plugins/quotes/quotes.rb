class Quotes
  include Cinch::Plugin

  $help_messages << '!quote  -  Get an awesome quote.'
  $help_messages << '!quote Awesome quote I found - author attribution  -  Add an awesome quote so someone can get it later.'

  match /quote(.*)/, method: :run_quotes

  def run_quotes(m, message = "")
    quote_source = QuoteSource.new(message)
    QuoteDisplay.output(m, quote_source.quote)
  end
end


class QuoteSource
  attr_reader :quote

  ATTRIBUTION_FORMAT = ' - '
  ACCEPTABLE_LENGTH = 'The Dude abides. - The Dude'.length
  QUOTES_FILE = 'plugins/quotes/resources/quotes.txt'
  QUOTES = IO.readlines(QUOTES_FILE)
  RANDOM_QUOTE = QUOTES[rand(QUOTES.length) - 1]

  def initialize(quote)
    quote = regularize_whitespace(quote)
    @quote = quote_is_invalid(quote) ? RANDOM_QUOTE : add_quote(quote)
  end

  private

  def add_quote(quote)
    file = File.open(QUOTES_FILE, 'a') {|file| file.puts quote}
  end

  def regularize_whitespace(quote)
    quote.strip.squeeze(' ') unless quote.nil?
  end

  def quote_is_invalid(quote)
    quote.nil? || quote.empty? || quote.length < ACCEPTABLE_LENGTH || !quote.include?(ATTRIBUTION_FORMAT)
  end
end


class QuoteDisplay
  class << self

    def output(m, quote)
      output = quote.nil? || quote.empty? ? 'Quote added.' : quote
      m.reply output
    end

  end
end