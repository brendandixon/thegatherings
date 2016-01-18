Dir[Rails.root.join("lib/*.rb"), Rails.root.join("lib/extensions/*.rb")].each {|file| load file}
