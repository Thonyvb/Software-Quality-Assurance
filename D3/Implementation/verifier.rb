require 'flamegraph'
require 'pathname'

require_relative 'ArgsChecker'
require_relative 'HashGenerator'
require_relative 'ErrorReport'
require_relative 'OrderChecker'
require_relative 'TransactionChecker'
require_relative 'TimeChecker'
require_relative 'PrevHashChecker'
require_relative 'HashChecker'
require_relative 'PrintBillcoins'

Flamegraph.generate('verifier_fgraph.html') do
	# raise "Enter a string." unless ARGV.count >= 1
	arg_checker = ArgsChecker::new

	if (arg_checker.check_args ARGV) < 0
		exit
	end

	filename = (ARGV[0]);
	pn = Pathname.new(filename)

	# check for exceptions
	if (arg_checker.check_file_existance pn) < 0 
		exit
	end

	history = File.readlines(filename)
	
	# helper method 
	def is_number? string
	  true if Float(string) rescue false
	end

	## generate hashs ##
	a_hash = HashGenerator::new
	hash_container = []
	i = 0
	for transaction in history
		hash_container[i] = a_hash.generate transaction
		i = i+1
	end

	an_error = ErrorReport::new

	## check order ##
	order_check = OrderChecker::new
	if (order_check.verify_order history) < 0
		exit
	end

	## Check transaction is valid ##
	## Nonegative Balance
	transaction_check = TransactionChecker::new
	people = transaction_check.verify_transaction history

	## Check timestamp ##
	## check nanoseconds ##
	time_check = TimeChecker::new
	if (time_check.check_time history) < 0
		exit
	end

	## prev hash comparisons ##
	prev_hash_check = PrevHashChecker::new
	if (prev_hash_check.verify_prev history) < 0
		exit
	end

	##compare if current hash is correct ##
	hash_check = HashChecker::new
	if (hash_check.verify_hash history, hash_container) < 0
		exit
	end

	## if valid print all billcoins ##
	bill_report = PrintBillcoins::new
	bill_report.printcoins people
end

