# Load puppetdb stuff
load 'config/lib/puppetdb.rb'

servers = query_puppetdb("resources","production","morgue")

if servers.nil?
  puts "Puppetdb returned 0 servers."
  exit 1
end

# puppetdb query returns then name of servers as a fqdn.
# need to remove .bigcommerce.com because there's no access to the public IP.

role(:app) {
  servers.to_a.map! { |x| x.sub(".bigcommerce.com",".obm.bigcommerce.com") }
}

set :graphite_url, "https://graphite.bigcommerce.net/events/"
require "graphite-notify/capistrano"
