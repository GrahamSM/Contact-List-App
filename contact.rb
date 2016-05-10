require 'csv'
require 'pry'
require 'pg'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  attr_accessor :name, :email, :number
  attr_accessor :id
  #@contact_file = "./contacts.csv"
  @@conn = PG.connect(
    host: 'localhost',
    dbname: 'contact_list',
    user: 'development',
    password: 'development'
  )
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  # @param number [String] The contact's phone number (optional)
  def initialize(name, email, id = nil)
    @name = name
    @email = email
    @id = id
  end

  # TODO: Exception/return value to inform user
  def save
    saved? ? update : insert
  end

  def has_number?
    x = @@conn.exec_params('SELECT * FROM numbers WHERE contact_id = $1::int', [id])
    !(x.values.empty?)
  end

  def get_number
    numbers = []
    nums = @@conn.exec_params('SELECT * FROM numbers WHERE contact_id = $1::int', [id])
    nums.each do |num|
      numbers << num["number"]
    end
    return numbers
  end


  def saved?
    self.id ? true : false
  end

  def update
    @@conn.exec_params('UPDATE contacts SET name = $1, email = $2 WHERE id = $3;', [name, email, id])
  end

  def insert
    @@conn.exec_params('INSERT INTO contacts (name, email) VALUES ($1, $2) RETURNING id', [name, email]) do |results|
      @id = results[0]["id"]
      self.update
    end
  end

  def destroy
    @@conn.exec('DELETE FROM contacts WHERE id = $1::int', [id])
  end
  # Provides functionality for managing contacts in the csv file.
  class << self

    def all
      contacts = []
      @@conn.exec('SELECT * FROM contacts;').each do |contact|
        contacts << Contact.new(contact["name"], contact["email"], contact["id"])
      end
      contacts
    end

    def find(id)
      results = @@conn.exec('SELECT * FROM contacts WHERE id = $1::int', [id])
      if results[0]
        Contact.new_from_row(results[0])
      end
    end

    def new_from_row(c)
      Contact.new(c["name"], c["email"], c["id"])
    end

    def search(term)
      results = []
      contacts = Contact.all
      contacts.each do |contact|
        if contact.name[term]
          results << contact
        end
      end
      results.each do |c|
        puts "Name: #{c.name}"
        puts "Email: #{c.email}"
      end
    end


    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    #def search(term)
    #  contacts = Contact.all
    #  contacts.each do |contact|
    #    if contact.name[term] || contact.email[term]
    #      puts "#{contact.name} (#{contact.email}) #{contact.number if contact.number}"
    #    elsif contact.number
    #      if contact.number[term]
    #        puts "#{contact.name} (#{contact.email}) #{contact.number}"
    #      end
    #    end
    #  end
    #end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    #def create(name, email, number = nil)
    #  contact = Contact.new(name, email, number)
    #  num=0
    #  flag = false
    #  File.readlines(@contact_file).each do |contact|
    #    contact = contact.split(",")
    #    if contact[0] == name
    #      flag = true
    #      break
    #      num+=1
    #    end
    #  end
    #  if !(flag)
    #    File.open(@contact_file, 'a') do |file|
    #      if !number.nil?
    #        file.puts name + ", " + email + ", " + number.join(", ")
    #      else
    #        file.puts name + ", " + email + ", "
    #      end
    #    end
    #    puts "#{name} added successfully with ID #{num+1}"
    #  else
    #    puts "Contact already exists"
    #  end
    #end

    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    #def find(id)
    #  contacts = Contact.all
    #  contact = contacts[id]
    #end


    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    #def all
    #  contacts = []
    #  File.readlines(@contact_file).each do |line|
    #    contact = line.split(', ')
    #    if contact.size == 3
    #      contacts << Contact.new(contact[0], contact[1], contact[2])
    #    else
    #      contacts << Contact.new(contact[0], contact[1])
    #    end
    #  end
    #  return contacts
    #end
  end
end
