require 'socket'

r_body = '<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
	<ProcessText xmlns="http://typograf.artlebedev.ru/webservices/">
	  <text>-"Typograph"</text>
      <entityType>4</entityType>
      <useBr>1</useBr>
      <useP>1</useP>
      <maxNobr>3</maxNobr>
      <quotA>laquo raquo</quotA>
      <quotB>bdquo ldquo</quotB>
	</ProcessText>
  </soap:Body>
</soap:Envelope>'

r_header = "POST /webservices/typograf.asmx HTTP/1.1
Host: typograf.artlebedev.ru
Content-Type: text/xml
Content-Length: #{r_body.length}
SOAPAction: \"http://typograf.artlebedev.ru/webservices/ProcessText\"

"
r_message = r_header + r_body

resp = nil

Socket.tcp('typograf.artlebedev.ru', 80) do |socket|
  socket.print r_message
  socket.close_write
  resp = socket.read
end

resp = resp.scan(/<ProcessTextResult>.+[\n\r]*.*<\/ProcessTextResult>/)

if resp.any?
  resp = resp.first
  resp = resp.gsub(/(<\/?ProcessTextResult>|\n|\r)/, '')
  p resp
end
