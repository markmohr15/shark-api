if %w[demo staging production].include? Rails.env
  Bugsnag.configure do |config|
    config.api_key = "fcd8562c7fc3dd8f707161314332ae3b"
  end
end
