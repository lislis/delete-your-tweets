defmodule DeleteYourTweets.SessionController do
  use DeleteYourTweets.Web, :controller

  def signin(conn, _params) do
    consumer_key = System.get_env("TWITTER_CONSUMER_KEY")
    consumer_secret = System.get_env("TWITTER_CONSUMER_SECRET")

    ExTwitter.configure(
      consumer_key: consumer_key,
      consumer_secret: consumer_secret)

    token = ExTwitter.request_token("http://127.0.0.1:4000/callback")
    {:ok, authenticate_url} = ExTwitter.authenticate_url(token.oauth_token)

    redirect(conn, external: authenticate_url)
  end

  def callback(conn, %{"oauth_token"=> oauth_token, "oauth_verifier" => oauth_verifier}) do
    {:ok, access_token} = ExTwitter.access_token(oauth_verifier, oauth_token)
    ExTwitter.configure(
      consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
      consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
      access_token: access_token.oauth_token,
      access_token_secret: access_token.oauth_token_secret)

    redirect(conn, to: "/")
  end
end
