require 'csv'
class ImportsController < ApplicationController
  def index
    # Creating an imports archive, to keep track of all uploads.
    @imports ||= Import.new
  end

  def create
    # return if no file is specified.
    if params[:import].nil?
      flash[:warning] = 'File is required.'
      redirect_to root_path
      return
    end
    import_file = params[:import][:import_file]
    path = Rails.root.join('public', 'uploads', import_file.original_filename)
    Dir.mkdir(IMPORTS_DIR) unless Dir.exists? IMPORTS_DIR
    File.open(path, 'wb') do |file|
      file.write(import_file.read)
    end
    Import.create(:time => Time.now)

    begin
      data = CSV.readlines(import_file.tempfile, { :col_sep => "\t" })
      revenue = 0
      data[1..-1].each do |row|
        user = User.create(:name => row[0])
        product = Product.create(:description => row[1], :price => row[2])
        merchant = Merchant.create(:address => row[4], :name => row[5])
        order = Order.create(:user => user, :product => product, :merchant => merchant, :purchase_count => row[3])
        revenue += order.product.price * order.purchase_count
      end

      flash[:success] = 'Gross Revenue: $%.2f' % revenue
    rescue => e
      Rails.logger.error(e.message)
      flash[:warning] = "Can not process: #{import_file.original_filename}"
    end
    redirect_to root_path
  end
end