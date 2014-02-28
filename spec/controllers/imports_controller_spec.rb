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

  describe 'POST to import with valid tsv file' do
    it 'should import file and return correct calculation of total revenue.' do
      @file = fixture_file_upload('files/example_input.tab', 'text/csv')
      class << @file
        # The reader method is present in a real invocation,
        # but missing from the fixture object for some reason.
        attr_reader :tempfile
      end
      post :create, :import => {:import_file => @file}
      flash[:success].should eql 'Gross Revenue: $95.00'
    end
  end
end
