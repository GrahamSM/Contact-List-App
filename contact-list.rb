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
          puts "#{num}: #{contact.name} (#{contact.email})"
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
        puts "Please enter a full name for the user"
        name = STDIN.gets.chomp #?
        puts "Please enter an email address for the user"
        email = STDIN.gets.chomp #?
        Contact.create(name,email)
      when /show/
        contact = Contact.find(argv[1].to_i)
        if contact
          puts "Contact name: #{contact.name}"
          puts "Contact e-mail: #{contact.email}"
        else
          puts "Contact not found"
        end
      when /search/
        contact = Contact.search(argv[1])
      else
        puts "Sorry, command not recognized"
      end

end
