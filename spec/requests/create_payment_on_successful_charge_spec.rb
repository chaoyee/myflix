require 'spec_helper'

describe "create payment on successful charge" do
  let(:event_data) do
    {
      "id"=> "evt_103GvK2MabSztOHhSYhuvSyF",
      "created"=> 1389191925,
      "livemode"=> false,
      "type"=> "charge.succeeded",
      "data"=> {
        "object"=> {
          "id"=> "ch_103GvK2MabSztOHhpJr7mduD",
          "object"=> "charge",
          "created"=> 1389191925,
          "livemode"=> false,
          "paid"=> true,
          "amount"=> 999,
          "currency"=> "usd",
          "refunded"=> false,
          "card"=> {
            "id"=> "card_103GvK2MabSztOHhWhwLB1Px",
            "object"=> "card",
            "last4"=> "4242",
            "type"=> "Visa",
            "exp_month"=> 1,
            "exp_year"=> 2016,
            "fingerprint"=> "nqcMZg1tfKVnv6vO",
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
          "captured"=> true,
          "refunds"=> [],
          "balance_transaction"=> "txn_103GvK2MabSztOHhr2UyJU8t",
          "failure_message"=> nil,
          "failure_code"=> nil,
          "amount_refunded"=> 0,
          "customer"=> "cus_3GvKuScPlMLe6O",
          "invoice"=> "in_103GvK2MabSztOHhnrceR3VM",
          "description"=> nil,
          "dispute"=> nil,
          "metadata"=> {}
        }
      },
      "object"=> "event",
      "pending_webhooks"=> 1,
      "request"=> "iar_3GvKcTmiTkMfuU"
    }
  end
  it "creates a payment with the webhook from stripe for charge succeeded", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)    
  end
  it "creates the payment assoicated with user", :vcr do
    bob = Fabricate(:user, customer_token: "cus_3GvKuScPlMLe6O")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(bob)
  end
  it "creates the payment with the amount", :vcr do
    bob = Fabricate(:user, customer_token: "cus_3GvKuScPlMLe6O")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end
  it "created the payment with reference id", :vcr do
    bob = Fabricate(:user, customer_token: "cus_3GvKuScPlMLe6O")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_103GvK2MabSztOHhpJr7mduD")
  end
end