require 'spec_helper'

feature "user sign in" do
  scenario "with valid email and password" do
    bob = Fabricate(:user)
    sign_in(bob)
    page.should have_content bob.full_name
  end
end