defmodule Dispatcher do
  use Matcher

  define_accept_types [
    html: [ "text/html", "application/xhtml+html" ],
    json: [ "application/json", "application/vnd.api+json" ],
  ]

  @any %{}
  @json %{ accept: %{ json: true } }
  @html %{ accept: %{ html: true } }

  # In order to forward the 'themes' resource to the
  # resource service, use the following forward rule.
  #
  # docker-compose stop; docker-compose rm; docker-compose up
  # after altering this file.
  #
  # match "/themes/*path", @json do
  #   Proxy.forward conn, path, "http://resource/themes/"
  # end

  match "/songs/*path" do
    Proxy.forward conn, path, "http://resource/songs/"
  end


  match "/bands/*path" do
    Proxy.forward conn, path, "http://resource/bands/"
  end

  match "/sessions/*path" do
    Proxy.forward conn, path, "http://login/sessions/"
  end

  match "/accounts/*path" do
    Proxy.forward conn, path, "http://registration/accounts/"
  end

  match "/games/*path" do
    Proxy.forward conn, path, "http://resource/games/"
  end

  match "/moves/*path" do
    Proxy.forward conn, path, "http://resource/moves/"
  end


  match "/mine/*path" do
    Proxy.forward conn, path, "http://myMicroservice/"
  end

  match "/ws/*path" do
    Proxy.forward conn, path, "http://myMicroservice:8080/"
  end

  match "/sparql/*path" do
    Proxy.forward conn, path, "http://db:8890/sparql"
  end

  match "_", %{ last_call: true } do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end
end
