require 'csv'
require 'pry'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  attr_accessor :name, :email
  @contact_file = "./contacts.csv"
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(name, email)
    # TODO: Assign parameter values to instance variables.
    @name = name
    @email = email
  end

  # Provides functionality for managing contacts in the csv file.
  class << self

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all
      contacts = []
      File.readlines(@contact_file).each do |line|
        contact = line.split(', ')
        contacts << Contact.new(contact[0], contact[1])
      end
      return contacts
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    def create(name, email)
      contact = Contact.new(name, email)
      File.open(@contact_file, 'a') do |file|
        file.puts name + ", " + email
      end
      num = 0
      File.readlines(@contact_file).each do |i|
        num+=1
      end
      puts "Contact created successfully with ID #{num}"
    end

    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      contacts = Contact.all
      binding.pry
      contact = contacts[id]
    end
    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)
      contacts = Contact.all
      contacts.each do |contact|
        if contact.name[term] || contact.email[term]
          puts "#{contact.name} (#{contact.email})"
        end
      end
    end

  end

end
