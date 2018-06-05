require 'date'
require 'time'
require 'twitter'
require 'faraday'
require 'aws/s3'
require 'csv'
require 'uuid'
require 'multi_json'
require 'uri'

# twitter setup
$twitclient = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["ROCITES_TWITTER_CONSUMER_KEY"]
  config.consumer_secret     = ENV["ROCITES_TWITTER_CONSUMER_SECRET"]
  config.access_token        = ENV["ROCITES_TWITTER_ACCESS_TOKEN"]
  config.access_token_secret = ENV["ROCITES_TWITTER_ACCESS_SECRET"]
end

# aws setup
$s3 = AWS::S3::Base.establish_connection!(
  :access_key_id     => ENV["AWS_S3_WRITE_ACCESS_KEY"], 
  :secret_access_key => ENV["AWS_S3_WRITE_SECRET_KEY"]
)

module Rocites
  def self.clean_desc2(y)
    y = y.gsub(/\n/, ' ')
    y.match(/^.{0,280}\b/)[0]
  end

  def self.tweet(x)
    puts 'sending tweet for "' + x["name"] + '"'

    if x["doi"].nil?
      url = URI.extract(x["citation"]).keep_if { |x| x.match(/https?/) }
      if url.empty?
        ""
      else
        url = url[0]
      end
    else
      url = "https://doi.org/" + x["doi"].delete('\\"')
    end

    tweet = "New @rOpenSci citation of our #rstats `%s` 📦 - %s" % [x['name'], url]
    tweet = clean_desc2(tweet)

    # if tweet already sent, skip
    mytweets = $twitclient.user_timeline;
    logg = []
    mytweets.each do |z|
      # logg << tweet.sub(/http.+/, '').casecmp(z.text.sub(/http.+/, '')) == 0
      logg << tweet.casecmp(z.text) == 0
    end
    if logg.include?(0)
      puts 'skipping, tweet already sent'
    else
      # not sent, sending it
      puts 'new citation for %s, sending tweet' % x["name"]
      $twitclient.update(tweet)
    end
  end

  # upload x hashes to S3
  def self.upload_s3(x)
    x.each do |i|
      AWS::S3::S3Object.store(UUID.generate + ".json", i.to_json, "rocites")
    end
  end

  # download all objects in the rocites S3 bucket, convert to array of hashes
  def self.download_s3
    x = AWS::S3::Bucket.find('rocites')
    all_hashes = x.map { |w| MultiJson.load(w.value.to_s) }
    return all_hashes
  end

  # get ropensci/roapi citations.csv file, convert to array of hashes
  def self.get_citations
    conn = Faraday.new(:url => 'https://raw.githubusercontent.com/ropensci/roapi/master/data/citations.csv') do |f|
      f.adapter Faraday.default_adapter
    end
    x = conn.get;
    x.body.force_encoding(Encoding::UTF_8);
    csv = CSV.parse(x.body, :col_sep => ";", :quote_char => "|", :headers => true);
    hsh = csv.map {|a| Hash[ a ] };
    return hsh
  end

  # get new citations, if any
  def self.new_citations
    puts "getting citations from github"
    ctz = self.get_citations
    puts "getting cached citations on s3"
    s3dat = self.download_s3

    # compare
    diffed = ctz - s3dat

    # return any new, nil if no new ones
    if diffed.empty?
      return nil
    else 
      # upload to s3
      puts "uploading new citations to s3"
      self.upload_s3(diffed)
      # return for tweeting
      return diffed
    end
  end

end
