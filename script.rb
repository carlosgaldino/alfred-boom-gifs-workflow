require 'json'

def item_xml(options = {})
  <<-ITEM
  <item arg="#{options[:arg]}" uid="#{options[:uid]}">
    <title>#{options[:title]}</title>
    <subtitle>#{options[:subtitle]}</subtitle>
    <icon>#{options[:path]}</icon>
  </item>
  ITEM
end

def match?(word, query)
  word.match(/#{query}/i)
end

gifs = JSON.parse(File.read(File.expand_path('~/.boom')))['lists'].first['gifs']

query = Regexp.escape(ARGV.first)

matches = gifs.select { |h| match?(h.keys.first, query) || match?(h.values.first, query) }

items = matches.map do |elem|
  key = elem.keys.first
  value = elem.values.first
  item_xml({ :arg => value, :uid => key, :title => key, :subtitle => value })
end.join

output = "<?xml version='1.0'?>\n<items>\n#{items}</items>"

puts output
