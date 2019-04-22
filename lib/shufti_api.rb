require "shufti_api/version"
require 'shufti_api/configuration'
require 'shufti_api/authorization'
require 'shufti_api/verification_response'
require 'httparty'
require 'base64'

module ShuftiApi
  
  include HTTParty
  
  base_uri "https://shuftipro.com"
  format :json
  
  @@configuration = Configuration.new
  
  def self.config(&block)
    yield(@@configuration)
  end
  
  def self.configuration
    @@configuration
  end
  
  def self.authorization_header
    "Basic #{Base64.strict_encode64("#{configuration.client_id}:#{configuration.secret_key}")}"
  end
end
