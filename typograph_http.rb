require 'net/http'
require 'nokogiri'

# Create te http object
http = Net::HTTP.new('typograf.artlebedev.ru', 80)
http.use_ssl = false
path = '/webservices/typograf.asmx'

# Create the SOAP Envelope
data = <<-EOF
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
  <ProcessText xmlns="http://typograf.artlebedev.ru/webservices/">
    <text>- "Typograph"</text>
      <entityType>4</entityType>
      <useBr>1</useBr>
      <useP>1</useP>
      <maxNobr>3</maxNobr>
      <quotA>laquo raquo</quotA>
      <quotB>bdquo ldquo</quotB>
  </ProcessText>
  </soap:Body>
</soap:Envelope>
EOF

# Set Headers
headers = {
  'Host' => 'typograf.artlebedev.ru',
  'Content-Type' => 'text/xml',
  #'Content-Length' => data.length,
  'SOAPAction' => "http://typograf.artlebedev.ru/webservices/ProcessText"
}

# Post the request
resp, data = http.post(path, data, headers)

r = Nokogiri::XML(resp.body)
rs = r.xpath("//soap:Envelope/soap:Body/als:ProcessTextResponse/als:ProcessTextResult", { "soap" => 'http://schemas.xmlsoap.org/soap/envelope/', "als" => 'http://typograf.artlebedev.ru/webservices/' })

p rs.text
