module Gunnar
  class Flow
    def self.filter(filter_klass, options = {})
      @filter = filter_klass.from_hash(options)
    end

    def self.decorator(decorator_klass, options = {})
      (@decorators ||= []) << {decorator_klass: decorator_klass, options: options}
    end

    def self.action(action_klass, options = {})
      (@actions ||= []) << {action_klass: action_klass, options: options}
    end

    def self.run(payload)
      if @filter.match? payload
        post = Bengt::Models::Post.new(payload)

        post = @decorators.inject(post) do |post, decorator|
          decorator[:decorator_klass].new(post, decorator[:options])
        end

        @actions.each do |action|
          action[:action_klass].new(action[:options]).perform(post)
        end

        sleep 1
      end
    end
  end
end
