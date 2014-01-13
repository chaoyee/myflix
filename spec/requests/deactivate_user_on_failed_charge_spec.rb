require 'spec_helper'

describe "deactivate user on failed charge" do
  let(:event_data) do
    {
      "id"=> "evt_103HiG2MabSztOHhz6MP5Y8B",
      "created"=> 1389373959,
      "livemode"=> false,
      "type"=> "charge.failed",
      "data"=> {
        "object"=> {
          "id"=> "ch_103HiG2MabSztOHhpgzBXLys",
          "object"=> "charge",
          "created"=> 1389373959,
          "livemode"=> false,
          "paid"=> false,
          "amount"=> 999,
          "currency"=> "usd",
          "refunded"=> false,
          "card"=> {
            "id"=> "card_103HiE2MabSztOHh1XsrTEJZ",
            "object"=> "card",
            "last4"=> "0341",
            "type"=> "Visa",
            "exp_month"=> 3,
            "exp_year"=> 2016,
            "fingerprint"=> "gz4YpFpfFs5O5vwa",
            "customer"=> "cus_3GvKuScPlMLe6O",
            "country"=> "US",
            "name"=> nil,
            "address_line1"=> nil,
            "address_line2"=> nil,
            "address_city"=> nil,
            "address_state"=> nil,
            "address_zip"=> nil,
            "address_country"=> nil,
            "cvc_check"=> "pass",
            "address_line1_check"=> nil,
            "address_zip_check"=> nil
          },
          "captured"=> false,
          "refunds"=> [],
          "balance_transaction"=> nil,
          "failure_message"=> "Your card was declined.",
          "failure_code"=> "card_declined",
          "amount_refunded"=> 0,
          "customer"=> "cus_3GvKuScPlMLe6O",
          "invoice"=> nil,
          "description"=> "payment with declined card",
          "dispute"=> nil,
          "metadata"=> {}
        }
      },
      "object"=> "event",
      "pending_webhooks"=> 1,
      "request"=> "iar_3HiGxqd4W9V1u0"
    }
  end
  it "deactivates a user with the web hook data from stripe for charge failed", :vcr do
    bob = Fabricate(:user, customer_token: "cus_3GvKuScPlMLe6O")
    post "/stripe_events", event_data
    expect(bob.reload).not_to be_active
  end  
end       