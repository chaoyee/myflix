require 'spec_helper'

feature "User interacts with the queue" do
  scenario "user adds and reorders videos in the queue" do
    animations = Fabricate(:category)
    bonds      = Fabricate(:video, title: "Bonds", category: animations)
    castle     = Fabricate(:video, title: "Castle", category: animations)
    toy        = Fabricate(:video, title: "Toy Story", category: animations)
    
    sign_in
    add_video_to_queue(bonds)
    expect_video_to_be_in_queue(bonds)

    visit video_path(bonds)
    expect_link_not_to_be_seen("+ My Queue")

    add_video_to_queue(castle)
    add_video_to_queue(toy) 

    set_video_position(bonds,  3)
    set_video_position(castle, 1)
    set_video_position(toy,    2)

    update_queue

    expect_video_position(castle, 1)  
    expect_video_position(toy,    2)
    expect_video_position(bonds,  3)    
  end

  def expect_video_to_be_in_queue(video)
    page.should have_content(video.title)
  end

  def expect_link_not_to_be_seen(link_text)
    page.should_not have_content(link_text)
  end

  def update_queue
    click_button "Update Instant Queue"
  end

  def add_video_to_queue(video)
    visit home_path
    click_on_video_on_home_page(video)
    click_link "+ My Queue"   
  end

  def set_video_position(video, position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do
      fill_in "queue_items[][position]", with: position
    end
  end

  def expect_video_position(video, position)    
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq(position.to_s)
  end

end