require 'spec_helper'

feature "user sign in" do
  scenario "with valid email and password" do
    bob = Fabricate(:user)
    sign_in(bob)
    page.should have_content bob.full_name
  end

  scenario "with deactivated user" do
    bob = Fabricate(:user, active: false)
    sign_in(bob)
    expect(page).not_to have_content bob.full_name
    expect(page).to have_content("Your account has been suspended, Please contact customer service.")
  end
end