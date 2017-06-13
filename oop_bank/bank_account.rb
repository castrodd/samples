class BankAccount
  attr_accessor :balance, :transactions, :transaction_number
  attr_reader :name
  @@minimum_balance = 200
  @@overdraft_fee = 50

  def initialize(balance, name)
    raise ArgumentError if balance < @@minimum_balance
    @balance = balance
    @name = name
    @transactions = []
    @transaction_number = 0
  end

  def deposit(amount)
    @transaction_number += 1
    @transactions << "#{@transaction_number}, deposit: #{amount}, balance: #{@balance + amount}"
    backup
    @balance += amount
  end

  def withdraw(amount)
    @transaction_number += 1
    if amount > @balance
      @transactions << "#{@transaction_number}, withdrawal: #{-(amount + @@overdraft_fee)}, balance: #{@balance - (amount + @@overdraft_fee)}"
      backup
      return @balance -= (amount + @@overdraft_fee)
    else
      @transactions << "#{@transaction_number}, withdrawal: #{-amount}, balance: #{@balance - amount}"
      backup
      @balance -= amount
    end
  end

  def transfer(amount, account)
    account.balance += amount
    account.transaction_number += 1
    account.transactions << "#{account.transaction_number}, transfer: #{amount}, balance: #{account.balance}"
    @transaction_number += 1
    if amount > @balance
      @transactions << "#{@transaction_number}, transfer: #{-(amount + @@overdraft_fee)}, balance: #{@balance - (amount + @@overdraft_fee)}"
      backup
      return @balance -= (amount + @@overdraft_fee)
    else
      @transactions << "#{@transaction_number}, transfer: #{-amount}, balance: #{@balance - amount}"
      backup
      @balance -= amount
    end
  end

  def log
    @transactions
  end

  def backup
    file = open("#{@name}.txt", "w")
    file << @transactions
    file.close
  end

  def self.recover(file_name)
    f = File.read(file_name).split(',')[-1]
    name = "#{file_name}".gsub('.txt', '')
    balance = f.gsub(/[^\d]/, '')
    BankAccount.new(balance.to_i, name)
  end

  def self.minimum_balance=(new_minimum)
    @@minimum_balance = new_minimum
  end

  def self.overdraft_fee=(new_fee)
    @@overdraft_fee = new_fee
  end
end
