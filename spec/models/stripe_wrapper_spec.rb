require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create", :vcr do
      it "creates a successful charge" do
        Stripe.api_key   = ENV['stripe_test_secret_key']

        token = Stripe::Token.create(
          :card => {
            :number    => "4242424242424242",
            :exp_month => 6,
            :exp_year  => 2018,
            :cvc       => 123
          }
        ).id

        response = StripeWrapper::Charge.create(
          amount: 100,
          card: token,
          description: "Sign up charge for test@test.com"
        )

        expect(response.amount).to   eq 100
        expect(response.currency).to eq 'usd'
      end
    end
  end
end
