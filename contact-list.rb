#!/usr/bin/env ruby
require_relative 'contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  puts "Here is a list of available commands: "
  puts "\tnew\t- Create a new contact"
  puts "\tlist\t- List all contacts"
  puts "\tshow ID\t- Show a contact with particular ID"
  puts "\tsearch\t- Search contacts"

  argv = ARGV
  contacts = Contact.all
    case argv[0]
      when /list/
        num = 0
        contacts.each do |contact|
          num+=1
          puts "#{num}: #{contact.name} (#{contact.email}) #{contact.number if contact.number}"
          if num%5 == 0
            puts "Hit <enter> to continue"
            enter = STDIN.gets
            if !(enter == "\n")
              puts "true"
              break
            end
          end
        end
        puts "#{num} records total"
      when /new/
        puts "Contact creator..."
        puts "Please enter a full name for the contact"
        name = STDIN.gets.chomp #?
        puts "Please enter an email address for #{name}"
        email = STDIN.gets.chomp #?
        numbers = []
        puts "If desired, please enter a phone number for #{name}. If not, simply hit <enter>"
        number = STDIN.gets.chomp
        while number != ""
          numbers << number
          puts "Please enter an additional number for #{name} if desired, or hit <enter> to continue"
          number = STDIN.gets.chomp
        end
        binding.pry
        if !(numbers.empty?)
          Contact.create(name, email, numbers)
        else
          Contact.create(name,email)
        end
      when /show/
        contact = Contact.find(argv[1].to_i)
        if contact
          puts "Contact name: #{contact.name}"
          puts "Contact e-mail: #{contact.email}"
          if contact.number
            puts "Contact phone number: #{contact.number}"
          end
        else
          puts "Contact not found"
        end
      when /search/
        contact = Contact.search(argv[1])
      else
        puts "Sorry, command not recognized"
      end

end
