module ClientMacros
  def local_client
    client = Lapse::Client.new(:access_token => '9774e653f7b3c1de5f21b61adc08ba24', :api_host => 'localhost:5000', :api_scheme => 'http')
  end

  def unauthenticated_monkeybars_production_client
    Lapse::Client.new(:client_token => '29756b7591819c57e01ac2c6d9ae5311')
  end
end
