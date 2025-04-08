require 'rack'
require 'webrick'
require_relative 'controllers/messages_controller'
require_relative 'controllers/slack_controller'

module Web
  class Server
    def self.start(port: 9292)
      # Creates application routes
      api_routes = Rack::Builder.new do
        map "/messages" do
          run MessagesController.new
        end

        map "/slack/events" do
          run SlackController.new
        end
      end.to_app

      # Server WEBrick
      server = WEBrick::HTTPServer.new(
        Port: port,
        AccessLog: [],
        Logger: WEBrick::Log.new($stdout)
      )

      server.mount_proc "/" do |req, res|
        path = req.path

        # Redirect API routes to the app
        if is_api_route?(path)
          env = {
            "REQUEST_METHOD" => req.request_method,
            "PATH_INFO" => req.path,
            "QUERY_STRING" => req.query_string,
            "rack.input" => StringIO.new(req.body || ""),
            "CONTENT_TYPE" => req["Content-Type"],
            "SCRIPT_NAME" => "",
            "SERVER_NAME" => "localhost",
            "SERVER_PORT" => port.to_s,
            "rack.url_scheme" => "http",
            "rack.errors" => $stderr,
            "rack.multithread" => false,
            "rack.multiprocess" => false,
            "rack.run_once" => false
          }

          status, headers, body = api_routes.call(env)
          res.status = status
          headers.each { |k, v| res[k] = v }

          body_content = ""
          body.each { |chunk| body_content << chunk }
          res.body = body_content

        else
          # Serve static files from the public/ folder
          file_path = File.join("public", path.empty? || path == "/" ? "index.html" : path)
          if File.exist?(file_path)
            res.body = File.read(file_path)
            res.content_type = WEBrick::HTTPUtils.mime_type(file_path, WEBrick::HTTPUtils::DefaultMimeTypes)
            res.status = 200
          else
            res.status = 404
            res.body = "Not found"
          end
        end
      end

      trap("INT") { server.shutdown }
      server.start
    end

    def self.is_api_route?(path)
      path.start_with?("/messages") || path.start_with?("/slack")
    end
  end
end
