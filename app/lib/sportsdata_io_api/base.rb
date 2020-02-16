class SportsdataIoApi::Base
  include HTTParty
  base_uri Rails.application.credentials[:SPORTSDATA_IO_API_URL]
  default_params key: Rails.application.credentials[:SPORTSDATA_IO_API_KEY]

  def self.find query={}
    response = get("/#{class_name.underscore}", {query: query, headers: headers})
    if response.success?
      response
    else
      raise_api_error response.response
    end
  rescue StandardError => exception
    raise_api_error exception.message
  end

  def self.find_by_id id
    response = get("/#{class_name.underscore}/#{id}", {headers: headers})
    if response.success?
      class_name.singularize.camelize.constantize.parse_json response
    else
      raise_api_error response.response
    end
  rescue StandardError => exception
    raise_api_error exception.message 
  end


  private

  def self.raise_api_error message
    #Bugsnag.notify message
    #nil
    throw "#{message}"
  end

  def self.class_name
    self.to_s.split("::")[1]
  end

  def self.headers
    {"Content-Type" => "application/json"}
  end

end