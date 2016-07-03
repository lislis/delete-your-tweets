defmodule DeleteYourTweets.TweetController do
  use DeleteYourTweets.Web, :controller

  def delete(conn, %{"older_than_months" => older_than_months}) do

    older_than_months
    |> fetch_tweets
    |> delete_tweets

    redirect conn, to: "/"
  end

  defp fetch_tweets(number_months) do
    ExTwitter.user_timeline(count: 3)
  end

  defp delete_tweets(tweets) do
    Enum.map(tweets,
      fn tweet ->
        ExTwitter.destroy_status(tweet.id)
      end)
  end
end
