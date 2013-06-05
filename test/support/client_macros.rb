module ClientMacros
  def authenticated_client
    Lapse::Client.new(:access_token => 'access_token')
  end

  def unauthenticated_client
    Lapse::Client.new
  end
end
