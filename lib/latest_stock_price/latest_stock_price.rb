# lib/latest_stock_price/latest_stock_price.rb
require 'net/http'
require 'json'

module LatestStockPrice
  RAPIDAPI_HOST = 'latest-stock-price.p.rapidapi.com'
  API_KEY = ENV['RAPIDAPI_KEY']  # Store your RapidAPI key in an environment variable

  class << self
    def price(stock_symbol)
      request("/price", { Symbol: stock_symbol })
    end

    def prices(stock_symbols)
      request("/prices", { Symbols: stock_symbols.join(',') })
    end

    def price_all
      request("/price_all")
    end

    private

    def request(endpoint, params = {})
      uri = URI("https://#{RAPIDAPI_HOST}#{endpoint}")
      uri.query = URI.encode_www_form(params)

      req = Net::HTTP::Get.new(uri)
      req['X-RapidAPI-Key'] = API_KEY
      req['X-RapidAPI-Host'] = RAPIDAPI_HOST

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http| http.request(req) }

      handle_response(response)
    end

    def handle_response(response)
      case response
      when Net::HTTPSuccess
        JSON.parse(response.body)
      else
        raise "API Request Failed: #{response.body}"
      end
    end
  end
end
