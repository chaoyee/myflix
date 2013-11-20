require 'spec_helper'

feature "user sign in" do
  scenario "with valid email and password" do
    bob = Fabricate(:user)
    visit sign_in_path
    fill_in "Email", with: bob.email
    fill_in "Password", with: bob.password
    click_button "Sign in"
    page.should have_content bob.full_name
  end
end