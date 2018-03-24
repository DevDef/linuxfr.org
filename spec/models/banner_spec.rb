# encoding: utf-8
# == Schema Information
#
# Table name: banners
#
#  id      :integer          not null, primary key
#  title   :string(255)
#  content :text(16777215)
#  active  :boolean          default(TRUE)
#

require 'spec_helper'

describe Banner do
  subject { FactoryGirl.build(:banner) }

  it { should be_valid }

  it "returns the text of a banner on random" do
    FactoryGirl.create(:banner)
    Banner.random.should be_present
  end
end
