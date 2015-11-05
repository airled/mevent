require 'curb'
require 'nokogiri'

class Message

  attr_accessor :text, :number

  def send
    html = get_html('http://freesms.mts.by/cgi-bin/cgi.exe?function=sms_send&isFree=1').text
    # captcha_url = "http://freesms.mts.by/cgi-bin/cgi.exe?function=sms_show_antispam_image&ImageNumber=#{captcha_num}"
    count = @text.size
    time = Time.now
    day = time.day.to_s
    mon = time.mon.to_s
    year = time.year.to_s
    hour = time.hour.to_s
    min = time.min
    table_record_id = html.xpath('//td[@class="number"]/input[@type="hidden"]/@value').text

    Curl.post('http://freesms.mts.by/cgi-bin/cgi.exe?function=sms_send', 
      {
        'MMObjectType' => '0',
        'isFree' => '1',
        'MMObjectID' => '',
        'Prefix' => '375',
        'To' => '37529' + @number,
        'NDC' => '29',
        'mobnum' => @number,
        'Msg' => @text,
        'count' => count,
        'Day' => day,
        'Mon' => mon,
        'Year' => year,
        'Hour' => hour,
        'Min' => min,
        'antispamText' => '3180', #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        'textTableRecordId' => table_record_id
      })
  end #send

  private

  def get_html(url)
    Nokogiri::HTML(Curl.get(url).body)
  end

end #class