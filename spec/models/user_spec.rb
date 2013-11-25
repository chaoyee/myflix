require 'spec_helper'

describe User do
  it { should validate_presence_of(:email)}
  it { should validate_presence_of(:password)}
  it { should validate_presence_of(:full_name)}
  it do 
    User.create(email: "test@test.com", password: "password", full_name: "Tester Tester")
    should validate_uniqueness_of(:email)
  end
  it { should have_many(:reviews).order(created_at: :desc)}
  it { should have_many(:queue_items).order(position: :asc)}
  it { should have_secure_password }
end  