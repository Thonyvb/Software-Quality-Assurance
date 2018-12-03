class HashGenerator
	def generate transaction
		newarr = transaction.split(/[\s|]+/)
		newarr = newarr.shift(newarr.length-1)
		st = newarr.join("|")
		hash_ = (st.unpack('U*').map { |x| (x ** 2000) * ((x + 2) ** 21) - ((x + 5 ) ** 3) }.reduce(:+) % 65536).to_s(16)
		return hash_
	end

	def compare tr1, tr2		
		return tr1 == tr2
	end
end
