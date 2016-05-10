class Number

  attr_reader :contact_id, :number

  @@conn = PG.connect(
    host: 'localhost',
    dbname: 'contact_list',
    user: 'development',
    password: 'development'
  )

  def initialize(contact_id, number, id = nil)
    @contact_id = contact_id
    @number = number
    @id = id
  end

  #def update
  #  @@conn.exec_params('UPDATE numbers SET contact_id = $1 WHERE id = $2;', [contact_id, id])
  #end

  def insert
    @@conn.exec_params('INSERT INTO numbers (contact_id, number) VALUES ($1, $2) RETURNING id', [contact_id, number]) do |results|
      @id = results[0]["id"]
      #self.update
    end
  end



end
