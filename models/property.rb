require('pg')
require('pry-byebug')

class PropertyTracker

  attr_accessor :address, :value, :year_built, :square_footage
  attr_reader :id

  def initialize ( house )
    @id = house['id'].to_i if house['id']
    @address = house['address']
    @value = house['value'].to_i
    @year_built = house['year_built'].to_i
    @square_footage = house['square_footage'].to_i
  end

  def save
    db = PG.connect( {dbname:'propertydb', host:'localhost'} )
    sql = "INSERT INTO property_tracker
    (address,
      value,
      year_built,
      square_footage)
    VALUES
      ($1, $2, $3, $4)
    RETURNING *"
    values = [@address, @value, @year_built, @square_footage]
    db.prepare("save", sql)
    @id= db.exec_prepared("save", values)[0]['id'].to_i()
    db.close()
  end

  def delete()
    db = PG.connect( {dbname:'propertydb', host:'localhost'} )
    sql = "DELETE FROM property_tracker
    (address,
      value,
      year_built,
      square_footage)
    WHERE id =($1)"
    values= [@id]
    db.prepare("delete", sql)
    db.exec_prepared("delete", values)
    db.close()
  end



  def update
    db = PG.connect({dbname:'propertydb', host:'localhost'})
    sql = "UPDATE property_tracker
      SET (address,
        value,
        year_built,
        square_footage)
      = ($1, $2, $3, $4)
        WHERE id = $5"
    values = [@address, @value, @year_built, @square_footage, @id]
    db.prepare("update", sql)
    db.exec_prepared("update", values)
    db.close
  end



  def PropertyTracker.all
      db = PG.connect( {dbname: 'propertydb', host:'localhost'} )
      sql = "SELECT * FROM property_tracker"
      db.prepare("all", sql)
      properties = db.exec_prepared("all")
      db.close
      return properties.map {|property| PropertyTracker.new(property)}
    end

    def PropertyTracker.delete_all
      db = PG.connect({dbname: 'propertydb', host: 'localhost'})
      sql = "DELETE FROM property_tracker"
      db.prepare("delete_all", sql)
      db.exec_prepared("delete_all")
      db.close
    end



    def PropertyTracker.find(id_number)
      db = PG.connect({dbname: 'propertydb', host: 'localhost'})
      sql = "SELECT * FROM property_tracker WHERE id = $1"
      values = [id_number]
      db.prepare("find", sql)
      # binding.pry()
      property = db.exec_prepared("find", values)[0]
      db.close()
      if property.count == 0
        # p "object with #{id_number} does not exist"
        # exit()
      end
      return PropertyTracker.new(property)
    end
end
