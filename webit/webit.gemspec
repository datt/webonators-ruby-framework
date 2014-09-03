Gem::Specification.new do |spec|
  spec.name  = "webit"
  spec.version = "0.0.1"
  spec.date  = "2014-08-30"
  spec.summary = "MVC Framework"
  spec.description = "Webit is MVC framework developed in Language Ruby. This will make an easy way for user to create web Application."
  spec.authors  = ["Taha Husain","Palash Kulkarni","Minakhi Najardhane","Kartik Nagre"]
  spec.email = ["taha.husain@weboniselab.com","palash.kulkarni@weboniselab.com","minakshi.najardhane@weboniselab.com","kartik.nagre@weboniselab.com"]
  spec.files = Dir["lib/generators/*.rb"] + Dir["lib/webit/*"] + ["lib/webit.rb"]
  spec.executables = ["webit"]
  spec.license = "MIT"
end
