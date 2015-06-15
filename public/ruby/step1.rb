require 'json'
require 'oauth'
require 'dotenv'

# --------------------------------------------------
# setting

hash = '#自分の人生においてトップ10に入るゲームをあげてけ'
Dotenv.load

consumer_key = ENV['CONSUMER_KEY']
consumer_secret = ENV['CONSUMER_SECRET']
access_token = ENV['ACCESS_TOKEN']
access_token_secret = ENV['ACCESS_TOKEN_SECRET']

consumer = OAuth::Consumer.new(
  consumer_key,
  consumer_secret,
  site:'https://api.twitter.com/'
)
endpoint = OAuth::AccessToken.new(consumer, access_token, access_token_secret)

# --------------------------------------------------
# functions

def getFirst(hash, endpoint)
  response = endpoint.get('https://api.twitter.com/1.1/search/tweets.json?q='+URI.escape(hash)+URI.escape('&count=100'))
  result = JSON.parse(response.body)
end

def getNext(result, endpoint)
  next_results = result['search_metadata']['next_results'] rescue nil
  if !next_results.nil?
    next_url = 'https://api.twitter.com/1.1/search/tweets.json'+next_results+URI.escape('&count=100')
    response = endpoint.get(next_url)
    result = JSON.parse(response.body)
    return result
  else
    return nil
  end
end

def isNext(result)
  result['search_metadata']['next_results'] rescue nil
end
def isStatus(result)
  result['statuses'] rescue nil
end

# --------------------------------------------------
# run

r = []
max = 0 # 回数制限を付ける場合
now = 0
result = getFirst(hash, endpoint)
result['statuses'].each do |o|
  r.push(o)
end

while isNext(result) do
  # get json
  result = getNext(result, endpoint)

  # add result
  if isStatus(result) != nil
    result['statuses'].each do |o|
      r.push(o)
    end
  else
    break
  end

  # is next
  now += 1
  if now > max && max > 0
    break
  end
  p now
end

# --------------------------------------------------
# output

File.write('dist/results.json', JSON.pretty_generate(r))
p r.count