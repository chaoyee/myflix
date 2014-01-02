require 'spec_helper'

feature 'User invites friend' do
  scenario 'User successfully invites friend and invitation is accepted', { js: true, vcr: true } do
    joe = Fabricate(:user)
    sign_in(joe)

    invite_a_friend
    friend_accepts_invitation
    friend_sign_in

    friend_should_follow(joe)
    inviter_should_follow_friend(joe)

    clear_email
  end

  def invite_a_friend
    visit new_invitation_path
    fill_in "Friend's Name", with: "Bob Test"
    fill_in "Friend's Email Address", with: "bob@test.com"
    fill_in "Invitation Message", with: "Hello! Come on to join it!"
    click_button "Send Invitation"
    sign_out  
  end

  def friend_accepts_invitation
    open_email "bob@test.com"
    current_email.click_link "Accept this invitation"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Bob Test"
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "6 - June", from: "date_month"
    select "2016", from: "date_year" 
    click_button "Sign Up"
  end

  def friend_sign_in
    visit sign_in_path
    fill_in "Email Address", with: "bob@test.com"
    fill_in "Password", with: "password"
    click_button "Sign in"
  end

  def friend_should_follow(user)
    #sign_in(user)
    click_link "People"
    expect(page).to have_content user.full_name
    sign_out
  end

  def inviter_should_follow_friend(inviter)
    sign_in(inviter)
    click_link "People"
    expect(page).to have_content "Bob Test"   
  end
end