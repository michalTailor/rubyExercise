#---budget_management---#
class BudgetManager
  require 'json'

  @@JSONFILENAME = "./records.json"

  def initialize(name, budget)
    @name = name
    @budget = budget
    @records = []
    File.write(@@JSONFILENAME, JSON.dump(@records))
  end

  def create_income_or_expanse(type)
    puts "Enter an amount: "
    amount = gets.chomp.to_f
    puts "Enter a description (optional):"
    description = gets.chomp.to_s

    #1. add to list:
    @records.push(
        {
          type: type,
          description: description,
          amount: amount
      }
    )
    #2.  calculate:
    if type == "income"
      @budget += amount
    elsif type == "expanse"
      @budget -= amount
    end

    #3.   update the JSON file:
    File.write(@@JSONFILENAME, JSON.dump(@records))
    #puts "*** Current balance: #{@budget}$ ***"

  end

  def list_all_records
    puts "Found #{@records.length} records\n"
    @records.each do |record|
      record[:description]? desc = "for #{record[:description]}" : desc = ""
      if record[:type] == "income"
        puts "#{record[:description]} | +#{record[:amount]}\n"
      elsif record[:type] == "expanse"
        puts "#{record[:description]} | -#{record[:amount]}\n"
      end
    end
  end

  def search_a_record(word)
    word_for_search = word.capitalize.downcase
    messageDetails = ""
    records_counter = 0
    @records.each do |record|
      if record[:description].capitalize.downcase.include? word
        records_counter +=1
        messageDetails += "#{record[:description]} | +#{record[:amount]}$ \n" if record[:type] == "income"
        messageDetails += "#{record[:description]} | -#{record[:amount]}$ \n" if record[:type] == "expanse"
      end
    end

    message = "Found #{records_counter} records for '#{word}':
-------------------------------"
    puts message
    puts messageDetails
  end

  def show_menu
    choice = "0"
    while choice != "exit"
      instructions = "
*** Current balance: #{@budget}$ ***
1) New income
2) New expanse
3) Search a record
4) List all records"
      puts instructions

      choice = gets.chomp.to_s
      case choice
      when "1"
        create_income_or_expanse("income")
      when "2"
        create_income_or_expanse("expanse")
      when "3"
        puts "Enter a word to search for: "
        word = gets.chomp.to_s
        search_a_record(word)
      when "4"
        list_all_records
      when "menu"
        show_menu
      when "exit"
        return
      else
        puts "Invalid choice. Please try again."
      end
    end
  end

  def createJSONFile(user_obj)
    file_name = "./#{@name}_#{@budget}.json"
    File.write(file_name, JSON.dump(user_obj))
  end

  def createUser
    saved_user = {}

    if (saved_user[:name] == @name && saved_user[:budget] == @budget)
      return false
    else
      puts "Hello #{@name}! Your budget is #{@budget}$"

      saved_user = {
        name: @name,
        budget: @budget
      }

      createJSONFile(saved_user)
      return true
    end
  end

end

#----------------------------------------------------------#
# main:
puts "Hello, what is your name?"
name = gets.chomp.to_s

puts "Great, please enter a budget?"
budget = gets.chomp.to_f

budgetInstance = BudgetManager.new(name,budget)
user = budgetInstance.createUser
if user #if it's new user:
  budgetInstance.show_menu
end
