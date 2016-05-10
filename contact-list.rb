#!/usr/bin/env ruby
require_relative 'contact'
require_relative 'number'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  puts "Here is a list of available commands: "
  puts "\tnew\t- Create a new contact"
  puts "\tlist\t- List all contacts"
  puts "\tshow ID\t- Show a contact with particular ID"
  puts "\tsearch\t- Search contacts"
  puts "\tdestroy\t- Remove contact"

  argv = ARGV
  contacts = Contact.all



    case argv[0]
      when /list/
        contacts.each do |contact|
          numbers = contact.get_number if contact.has_number?
          puts "#{contact.id}: #{contact.name} (#{contact.email}) #{numbers.join(', ') if !numbers.nil?}"
        end
      when /number/
        puts "Please enter the contact ID"
        id = STDIN.gets.chomp
        puts "Please enter the phone number for the contact"
        num = STDIN.gets.chomp
        number = Number.new(id,num)
        number.insert
      when /new/
        puts "Contact creator..."
        #puts "Please enter a full name for the contact"
        #name = STDIN.gets.chomp #?
        #puts "Please enter an email address for #{name}"
        #email = STDIN.gets.chomp #?
        #numbers = []
        #puts "If desired, please enter a phone number for #{name}. If not, simply hit <enter>"
        #number = STDIN.gets.chomp
        #while number != ""
        #  numbers << number
        #  puts "Please enter an additional number for #{name} if desired, or hit <enter> to continue"
        #  number = STDIN.gets.chomp
        #end
        #binding.pry
        #if !(numbers.empty?)
        #  Contact.create(name, email, numbers)
        #else
        puts "Please enter a name"
        name = STDIN.gets.chomp
        puts "Please enter an email"
        email = STDIN.gets.chomp
        result = Contact.search(name)
        if result.empty?
          contact = Contact.new(name, email)
          contact.save
        else
          puts "Contact already exists in the database"
        end
        #end
      when /show/
        contact = Contact.find(argv[1].to_i)
        if contact
          puts "Contact name: #{contact.name}"
          puts "Contact e-mail: #{contact.email}"
          puts "Contact ID: #{contact.id}"
          if contact.number
            puts "Contact phone number: #{contact.number}"
          end
        else
          puts "Contact not found"
        end
      when /search/
        contact = Contact.search(argv[1])
      when /update/
        the_contact = Contact.find(argv[1])
        puts "Selected contact: #{the_contact.name} ---- #{the_contact.email}"
        puts "Please enter a new name for the contact: (or hit <enter> to skip)"
        new_name = STDIN.gets.chomp
        puts "Please enter a new email for the contact: (or hit <enter> to skip)"
        new_email = STDIN.gets.chomp
        if !(new_name.empty?)
          the_contact.name = new_name
        end
        if !(new_email.empty?)
          the_contact.email = new_email
        end
        the_contact.save
      when /destroy/
        the_contact = Contact.find(argv[1])
        the_contact.destroy
      else
        puts "Command not recognized"
      end


end
