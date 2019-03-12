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

desc "find citation matching a DOI"
task :search, [:doi] do |task, args|
  puts "searching for #{args[:doi]}"
  obj = Rocites.find_citation_by_doi(args[:doi])
  if obj.nil?
    puts args[:doi] + " not found"
  else
    puts "Found citation: " + File.basename(obj[0].citation) + " for #{args[:doi]}"
  end
end

desc "delete citation matching a DOI"
task :delete, [:doi] do |task, args|
  puts "searching for #{args[:doi]}"
  begin
    obj = Rocites.delete_citation_by_doi(args[:doi])
    puts "#{args[:doi]} deleted"
  rescue Exception => e
    puts e.message
  end
end
