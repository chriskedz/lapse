module Lapse
  # Transports are a way for the client to communicate with the API.
  module Transport
    Dir[File.expand_path('../transport/*.rb', __FILE__)].each { |f| require f }

    # Transport adapter map
    TRANSPORT_MAP = {
      :http => Lapse::Transport::HTTP
    }
  end
end
