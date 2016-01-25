Dir.glob("#{Rails.root}/lib/extensions/*.rb") do |f|
  load f
end
