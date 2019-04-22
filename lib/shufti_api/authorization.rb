require 'open-uri'

module ShuftiApi
  module Authorization
  
    def self.verify_document(image_url, options = {})
      req_body = {}
      req_body["document"] = options
      
      req_body["reference"] = "Ref-"+ (0...8).map { (65 + rand(26)).chr }.join
      req_body["callback_url"] = ShuftiApi.configuration.callback_url
      req_body["document"]["proof"] = Base64.encode64(open(image_url).read)
      
      response = ShuftiApi.post('/api/',
                                body: req_body.to_json,
                                headers: {
                                    "Authorization" => ShuftiApi.authorization_header,
                                    "Content-Type" => 'application/json'
                                }).response

      ShuftiApi::VerificationResponse.new(response)
    end
  end
end