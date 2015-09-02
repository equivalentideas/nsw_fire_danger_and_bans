# This is a template for a Ruby scraper on morph.io (https://morph.io)
# including some code snippets below that you should find helpful

require 'scraperwiki'
require 'mechanize'

agent = Mechanize.new

# Read in a page
page = agent.get("http://www.rfs.nsw.gov.au/fire-information/fdr-and-tobans")
table = page.at('table.danger-ratings-table')
rows = table.at(:tbody).search("tr").map

rows.each do |row|
  fire_area = {
    date_scraped: Date.today.to_s,
    nsw_fire_area: row.search(:td)[0].text,
    fire_danger_level_today: row.search(:td)[1].text,
    total_fire_ban_today: row.search(:td)[2].text.strip,
    fire_danger_level_tomorrow: row.search(:td)[3].text,
    total_fire_ban_tomorrow: row.search(:td)[4].text,
    councils_affected: row.search(:td)[5].text.gsub(";", ",")
  }

  p fire_area

  # # Write out to the sqlite database using scraperwiki library
  ScraperWiki.save_sqlite([:date_scraped, :nsw_fire_area], fire_area)
end


# You don't have to do things with the Mechanize or ScraperWiki libraries.
# You can use whatever gems you want: https://morph.io/documentation/ruby
# All that matters is that your final data is written to an SQLite database
# called "data.sqlite" in the current working directory which has at least a table
# called "data".
