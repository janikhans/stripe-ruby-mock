module StripeMock
  module RequestHandlers
    module ParamValidators

      def validate_create_plan_params(params)
        params[:id] = params[:id].to_s

        @base_strategy.create_plan_params.keys.each do |name|
          next if name == :amount
          message = "Missing required param: #{name}."
          raise Stripe::InvalidRequestError.new(message, name) if params[name].nil?
        end

        if plans[ params[:id] ]
          raise Stripe::InvalidRequestError.new("Plan already exists.", :id)
        end

        if params[:billing_scheme] == 'per_unit'
          raise Stripe::InvalidRequestError.new("Plans require an amount parameter to be set.", name) if params[:amount].nil?
          raise Stripe::InvalidRequestError.new("Invalid integer: #{params[:amount]}", :amount) unless params[:amount].integer?
        end
      end

    end
  end
end
