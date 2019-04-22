class ShuftiApi::VerificationResponse
  
  module Exceptions
    class VerficiationError < StandardError; end
    class HTTPError < StandardError; end
    class Forbidden < StandardError; end
  end
  
  attr_reader :raw_response,
              :reference,
              :event,
              :error,
              :verification_url,
              :verification_data,
              :declined_reason,
              :status,
              :verified
  
  def initialize(raw_response)
    @raw_response = raw_response
    parse_response
  end
  
  def verified?
    @verified
  end
  
  def forbidden?
    @status == 403
  end
  
  def success?
    @status == 200
  end
  
  private
  
  def parse_response
    @status = raw_response.code.to_i
    raise Exceptions::Forbidden, JSON.parse(raw_response.body)["error"]["message"] if forbidden?
    raise Exceptions::HTTPError, "Request returned #{self.status}" unless success?
    
    json_response = raw_response.parsed_response
    
    @reference = json_response.reference
    @event = json_response.event
    @error = json_response.error
    @verification_url = json_response.verification_url
    @verified = json_response.verification_result.zero? ? false : true
    @verification_data = json_response.verification_data
    @declined_reason = json_response.declined_reason
    
    raise Exceptions::VerficiationError, "Requested error: #{self.error}" if error?
    
  end
  
  def error?
    @error.present?
  end
end