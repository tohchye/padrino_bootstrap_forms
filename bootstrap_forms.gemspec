$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "bootstrap_forms"
  s.version     = "2.0.1"
  s.author      = "Seth Vargo"
  s.email       = "sethvargo@gmail.com"
  s.homepage    = "https://github.com/sshaw/padrino_bootstrap_forms"
  s.summary     = "Padrino Bootstrap Forms makes Twitter's Bootstrap on Padrino easy!"
  s.description = <<-DESC
	Padrino Bootstrap Forms is port of Seth Vargo's Bootstrap Forms gem for Rails. 
        It makes Twitter's Bootstrap on Padrino easy to use by creating helpful form builders that minimize markup in your views
  DESC
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "padrino-helpers", "~> 0.10.6"
  s.add_development_dependency "rake"
  s.add_development_dependency "rack-test"
  s.add_development_dependency "rspec", "~> 2.9.0"
  s.add_development_dependency "activesupport", ">= 3"
end
