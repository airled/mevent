require 'nokogiri'
require 'curb'
require_relative './init/models'

source = 'http://www.ticketpro.by'
current_page = source + '/jnp/music/index.html'

while (current_page != source) do
  html = Nokogiri::HTML(Curl.get(current_page).body)
  p current_page
  html.xpath('//div[@class="event vevent"]').map do |event|
    Concert.create
  end
  current_page = source + html.xpath('//a[@class="normal"]/@href').text
end
