require 'sinatra'
require 'mysql'

include FileUtils::Verbose

get '/' do
	erb :home
end

get '/newevent' do
	erb :newevent
end

post '/newevent' do
	@eventName = params['eventName']
	@eventDate = params['eventDate']
	@eventImageUrl = 'public/images/' + params['eventImage'][:filename]
	@eventImageData = params['eventImage'][:tempfile]
	File.open(@eventImageUrl, "w") do |f|
    	f.write(@eventImageData.read)
	end
	begin
		db = Mysql::new("localhost", "aecc", "password", "aeccdb")
		db.query("INSERT INTO events(name, eventdate, image) VALUES ('#{@eventName}', '#{@eventDate}', '#{@eventImageUrl}')")
		db.close
	rescue Mysql::Error => e
		@errormessage = e
		db.close if db
		erb :neweventfail
	end
	erb :neweventsuccess
end