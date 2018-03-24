namespace :payment_summary do
  desc "To run payment cycl"
  task :process => :environment do
    PaymentSummary.new.process
  end

end