require './bank_account'

describe BankAccount do
  context "has a balance" do
    let(:account) do
      account = BankAccount.new(500, "Sarah")
    end

    it "is created with an opening balance and the name of the client" do
      expect(account).to be_a(BankAccount)
    end

    it "can report it's balance" do
      expect(account.balance).to eq(500)
    end
  end

  context "making a deposit" do
    let(:account) do
      account = BankAccount.new(500, "Sarah")
      account.deposit(500)
      account
    end

    it "balance is increased" do
      expect(account.balance).to eq(1000)
    end
  end

  context "making a withdrawal" do
    let(:account) do
      account = BankAccount.new(500, "Sarah")
      account.withdraw(200)
      account
    end

    it "balance is decreased" do
      expect(account.balance).to eq(300)
    end

    it "charges an overdraft fee if account is overdrafted" do
      account.withdraw(350)
      expect(account.balance).to eq(-100)
    end
  end

  context "transfering funds" do
    account_1 = BankAccount.new(500, "Sarah")
    account_2 = BankAccount.new(600, "Sam")
    account_3 = BankAccount.new(700, "Jim")
    account_4 = BankAccount.new(400, "Jane")
    account_1.transfer(100, account_2)

    it "account balance is decreased" do
      expect(account_1.balance).to eq(400)
    end

    it "charges an overdraft fee if account is overdrafted" do
      account_3.transfer(750, account_4)
      expect(account_3.balance).to eq(-100)
    end

    it "other account balance is increased" do
      expect(account_2.balance).to eq(700)
    end
  end

  context "minimum balance" do
    it "raises an error if opening balance is too low" do
      expect{BankAccount.new(150, "Sandra")}.to raise_error(ArgumentError)
    end
    it "does NOT raise an error if opening balance is over minimum balance" do
      expect{BankAccount.new(250, "Sonny")}.not_to raise_error
    end
    it "allows the bank owner to change the minimum balance" do
      expect(BankAccount.minimum_balance=(300)).to eq(300)
    end
  end

  context "overdraft fee" do
    it "allows the bank owner to set amount of the fee" do
      expect(BankAccount.overdraft_fee=(100)).to eq(100)
    end
  end

  context "logging transactions" do
    account = BankAccount.new(500, "Mary")
    another_account = BankAccount.new(500, "Mark")
    account.deposit(50)
    account.withdraw(100)
    account.transfer(25, another_account)
    another_account.transfer(75, account)
    it "stores all transactions for future reference" do
      expect(account.log).to eq(["1, deposit: 50, balance: 550", "2, withdrawal: -100, balance: 450", "3, transfer: -25, balance: 425", "4, transfer: 75, balance: 500"])
    end
  end

  context "logs transaction history in backup file" do
    it "follows every transaction by saving history to a file" do
      account = BankAccount.new(1000, "John")
      account.deposit(200)
      account.withdraw(50)
      account.deposit(100)
      expect(File).to exist("#{account.name}.txt")
    end
  end

  context "recovery" do
    account = BankAccount.new(2000, "Regina")
    account.deposit(200)
    account.withdraw(25)
    account.deposit(25)
    restored = BankAccount.recover("Regina.txt")
    it "restores bank account with correct owner" do
      expect(restored.name).to eq('Regina')
    end
    it "restores correct balance" do
       expect(restored.balance).to eq(2200)
    end
  end

end
