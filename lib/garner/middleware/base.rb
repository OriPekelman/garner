# based on https://github.com/intridea/grape/blob/master/lib/grape/middleware/base.rb
module Garner
  module Middleware
    class Base
      attr_reader :app, :env, :options

      # @param [Rack Application] app The standard argument for a Rack middleware.
      # @param [Hash] options A hash of options, simply stored for use by subclasses.
      def initialize(app, options = {})
        @app = app
        @options = default_options.merge(options)
      end

      def default_options; {} end

      def call(env)
        dup.call!(env)
      end

      def call!(env)
        @env = env
        before
        @app_response = @app.call(@env)
        after || @app_response
      end

      # @abstract
      # Called before the application is called in the middleware lifecycle.
      def before; end
      # @abstract
      # Called after the application is called in the middleware lifecycle.
      # @return [Response, nil] a Rack SPEC response or nil to call the application afterwards.
      def after; end

      def request
        Rack::Request.new(self.env)
      end

      def response
        Rack::Response.new(@app_response)
      end

    end
  end
end

