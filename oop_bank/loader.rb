def recover(file_name)
  f = File.read(file_name).split(',')[-1]
  name = "#{file_name}".gsub('.txt', '')
  balance = f.gsub(/[^\d]/, '').to_i
  f.close
  BankAccount.new(name, balance)
end

recover('John.txt')
