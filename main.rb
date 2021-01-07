SPECTRUM_SPREADSHEET = "/Users/robertgrayson/spectrum.csv"

require 'net/http'
require 'date'
require 'csv'

class SpectrumSnitch
  def initialize(spectrum_csv_path)
    @spectrum_csv_path = "/Users/robertgrayson/spectrum.csv"
    @full_datetime = Time.now
    @string_full_datetime = @full_datetime.to_s
    @string_date = Date.today.to_s
  end

  def run
    begin
      resp = Net::HTTP.get_response(URI("https://news.ycombinator.com"))
      @state = "connected"
      data = [@string_full_datetime, @string_date, @state]
      `echo #{data.join(",")} >> #{@spectrum_csv_path}`
    rescue SocketError, Net::OpenTimeout
      @state = "disconnected"
      data = [@string_full_datetime, @string_date, @state]
      `echo #{data.join(",")} >> #{@spectrum_csv_path}`
    end
  end
end
SpectrumSnitch.new(SPECTRUM_SPREADSHEET).run
