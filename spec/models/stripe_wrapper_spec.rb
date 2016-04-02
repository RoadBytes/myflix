require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      it "creates a successful charge" do
        VCR.use_cassette("StripeWrapper/StripeWrapper/Charge/create_token") do
          @token = Stripe::Token.create(
            :card => {
              :number    => "4242424242424242",
              :exp_month => 6,
              :exp_year  => 2018,
              :cvc       => 123
            }
          ).id
        end

        VCR.use_cassette("StripeWrapper/StripeWrapper/Charge/create_charge") do
          @response = StripeWrapper::Charge.create(
            amount: 100,
            card: @token,
            description: "Sign up charge for test@test.com"
          )
        end

        expect(@response.amount).to   eq 100
        expect(@response.currency).to eq 'usd'
      end
    end
  end
end
