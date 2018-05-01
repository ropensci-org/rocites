require_relative 'rocites'

desc "checks for new citations and sends tweet for each"
task :run do
  citations = Rocites.new_citations
  if citations.nil?
    puts "no new citations"
  else 
    citations.each do |x|
      Rocites.tweet(x)
      sleep rand(5..16)
    end
  end
end

desc "gets new citations"
task :new do
  citations = Rocites.new_citations
  if citations.nil?
    puts "no new citations"
  else 
    citations.each do |x|
      puts x
    end
  end
end
