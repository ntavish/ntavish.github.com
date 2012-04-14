desc "deploy site to gitready.com"
desc "Unpublish all posts"
task :unpublish do
  Dir["_posts/*.*"].each do |post|
    puts "Unpublishing #{post}"
    lines = File.readlines(post)
    lines.insert(1, "published: false\n")
    lines.delete(2)
    File.open(post, "w") { |f| f.write lines.join }
  end
end
