require 'spec_helper'

feature 'user following' do
  scenario "user follows and unfollows someone" do
    bob = Fabricate(:user)
    category = Fabricate(:category)
    video = Fabricate(:video, category: category)
    Fabricate(:review, user: bob, video: video)
    
    sign_in
    click_on_video_on_home_page(video)

    click_link bob.full_name
    click_link "Follow"
    expect(page).to have_content(bob.full_name)

    unfollow(bob)
    expect(page).not_to have_content(bob.full_name)
  end

  def unfollow(user)
    find("a[data-method='delete']").click
  end
end