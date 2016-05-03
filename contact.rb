require 'csv'
require 'pry'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  attr_accessor :name, :email, :number
  @contact_file = "./contacts.csv"
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  # @param number [String] The contact's phone number (optional)
  def initialize(name, email, number = nil)
    # TODO: Assign parameter values to instance variables.
    @name = name
    @email = email
    @number = number
  end

  # Provides functionality for managing contacts in the csv file.
  class << self

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all
      contacts = []
      File.readlines(@contact_file).each do |line|
        contact = line.split(', ')
        if contact.size == 3
          contacts << Contact.new(contact[0], contact[1], contact[2])
        else
          contacts << Contact.new(contact[0], contact[1])
        end
      end
      return contacts
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    def create(name, email, number = nil)
      contact = Contact.new(name, email, number)
      binding.pry
      num=0
      flag = false
      File.readlines(@contact_file).each do |contact|
        contact = contact.split(",")
        if contact[0] == name
          flag = true
          break
          num+=1
        end
      end
      if !(flag)
        File.open(@contact_file, 'a') do |file|
          if !number.nil?
            file.puts name + ", " + email + ", " + number.join(", ")
          else
            file.puts name + ", " + email + ", "
          end
        end
        puts "#{name} added successfully with ID #{num+1}"
      else
        puts "Contact already exists"
      end
    end

    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      contacts = Contact.all
      contact = contacts[id]
    end
    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)
      contacts = Contact.all
      contacts.each do |contact|
        if contact.name[term] || contact.email[term]
          puts "#{contact.name} (#{contact.email}) #{contact.number if contact.number}"
        elsif contact.number
          if contact.number[term]
            puts "#{contact.name} (#{contact.email}) #{contact.number}"
          end
        end
      end
    end

  end

end
