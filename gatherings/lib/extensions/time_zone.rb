module Extensions
  module TimeZone
    extend ActiveSupport::Concern

    module ClassMethods
    
      def zone_names(*args)
        options = args.extract_options!

        @us_names ||= ActiveSupport::TimeZone.us_zones.map{|tz| tz.name}
        @all_names ||= ActiveSupport::TimeZone.all.map{|tz| tz.name}

        return @all_names if options[:all]
        @us_names
      end
    
    end

  end
end

ActiveSupport::TimeZone.send(:include, Extensions::TimeZone)
