require 'spec_helper'

describe ImportsController do
  describe 'POST to import without file' do
    before { post :create }
    it 'should redirect to home' do
      response.should redirect_to root_path
    end
    it 'should returns error saying no file specified' do
      flash[:warning].should eql 'File is required.'
    end
  end
end
