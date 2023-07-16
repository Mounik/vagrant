current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                'mounik'
client_key               "mounik.pem"
validation_client_name   'belive'
validation_key           "belive.pem"
chef_server_url          'https://chef-server/organizations/belive'
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]

knife[:editor]="vim"
