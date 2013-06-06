require 'thor'
require 'faraday'
require 'faraday_middleware'
require 'addressable/uri'
require 'yaml'

module Lapse
  class Cli < Thor
    desc 'signin', 'Signs the user in by passing in a twitter token'
    def signin(host, token)
      result = unauthenticated_client(host).authenticate(token)

      self.auth_data = {
        :access_token => result['access_token'],
        :api_host => host
      }

      result = ["Signed in as #{result.user.username}"]
      result << " on #{host}" if host
      puts result.join('')
    end

    desc 'signout', 'Signs the user out'
    def signout
      File.delete config_file
      puts 'Signed out'
    end

    desc 'create_clip', 'Creates a clip'
    def create_clip(title, *image_paths)
      clip = authenticated_client.create_clip(title)
      puts "Created clip id #{clip.id}"

      frames = image_paths.each do |image_path|
        upload_frame(clip.id, image_path)
      end

      authenticated_client.accept_frames(clip.id, frames.map(&:id))

      puts 'Publishing clip'
      authenticated_client.publish_clip(clip.id)

      puts "#{api_host}/#{clip.slug}"
    end

    desc 'upload_frame', 'Uploads and accepts an image to a clip'
    def upload_frame(clip_id, image_path)
      new_frame = authenticated_client.create_frame(clip_id)
      file_upload = Faraday::UploadIO.new(image_path, 'image/jpeg')
      params = new_frame.upload_params.to_hash.merge({'file' => file_upload })

      conn = Faraday.new do |c|
        c.use Faraday::Request::Multipart
        c.adapter :net_http
      end
      response = conn.post(new_frame.upload_url, params)

      if response.status == 303
        conn.head response.headers['location']
      else
        raise response.body
      end

      putc '*'

      new_frame
    end

    desc 'photobooth', 'Runs a photobooth'
    option :url
    method_option :open, :aliases => "-o", desc: "Open the clip"
    def photobooth(title, frame_count = 10)
      clip = authenticated_client.create_clip(title)

      unless options[:url]
        puts "Install imagesnap via \`brew install imagesnap\` to use your local camera."
        return
      end

      frames = frame_count.to_i.times.map do |i|
        if options[:url]
          file = download_image(options[:url])
        else
          file = Tempfile.new(['photobooth', '.jpg'], encoding: 'BINARY')
          system "imagesnap #{file.path} > /dev/null"
        end

        upload_frame clip.id, file.path
      end

      authenticated_client.accept_frames(clip.id, frames.map(&:id))

      authenticated_client.publish_clip(clip.id)

      url = "#{api_host}/#{clip.slug}"

      if options[:open]
        system "open #{url}"
      else
        system "echo #{url} | pbcopy"
      end

      puts "\n#{url}"
    end

    protected

    def download_image(url)
      uri = Addressable::URI.parse(url)

      conn = Faraday.new do |c|
        #c.use FaradayMiddleware::FollowRedirects, limit: 3
        c.adapter :net_http
      end

      if uri.user
        conn.basic_auth(uri.user, uri.password)
      end

      response = conn.get(url)
      validate_response(url, response)

      convert_to_tempfile(response.body)
    end

    def validate_response(url, response)
      raise "#{url} not found" if response.status == 404
      raise "#{response.status} - #{response.body}" unless (200..300).include?(response.status)
      raise "#{url} has no data" unless response.body.length > 10
    end

    def convert_to_tempfile(data)
      file = Tempfile.open(['http', '.jpg'], encoding: 'BINARY')
      file.write data
      file.close
      file
    end

    def unauthenticated_client(host = api_host)
      options = {}.merge(server_options(host))
      Lapse::Client.new(options)
    end

    def authenticated_client(host = api_host)
      options = {:access_token => access_token}.merge(server_options(host))
      Lapse::Client.new(options)
    end

    def server_options(host)
      if host
        uri = Addressable::URI.parse(host)
        {:api_scheme => uri.scheme, :api_host => [uri.host, uri.port].compact.join(':')}
      else
        {}
      end
    end

    def access_token
      auth_data[:access_token]
    end

    def api_host
      auth_data[:api_host]
    end

    def auth_data
      @app_token ||= begin
        if File.exist?(config_file)
          YAML.load(File.open(config_file).read)
        else
          {}
        end
      end
    end

    def auth_data=(val)
      @app_token = val
      File.open(config_file, 'w+') do |f|
        f.write(YAML.dump(val))
      end
      @app_token
    end

    def config_file
      File.expand_path('~/.lapse')
    end
  end
end
