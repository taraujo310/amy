require "byebug"
require "sqlite3"
require_relative "util"

DB = SQLite3::Database.new "test.db"

module Amy
  module Model
    class SQLite
      def initialize(data = {})
        define_attributes(data)
      end

      def save!
        unless id
          self.class.create attributes
          return true
        end

        fields = attributes.map { |k, v| "#{k} = #{self.class.to_sql(v)}" }.join(",")

        DB.execute <<~SQL.strip
          UPDATE #{self.class.table} SET #{fields} WHERE id = #{attributes["id"]}
        SQL

        true
      end

      def save
        save! rescue false
      end

      def define_attributes(attrs)
        column_names = self.class.schema.keys

        column_names.map { |attr_name|
          [attr_name, attrs[attr_name.to_s] || attrs[attr_name.to_sym]]
        }.each { |(name, value)| define_attribute_with_accessor(name, value)  }
      end

      def define_attribute_with_accessor(name, value)
        instance_variable_set("@#{name}", value)
        self.class.attr_accessor name
      end

      def attributes
        self.class.columns.map { |name| [name, instance_variable_get("@#{name}")] }.to_h
      end

      class << self
        def table
          Amy.to_snake_case name
        end

        def schema
          return @schema if @schema

          infos = DB.table_info(table)
          @schema = infos.map { |col| col.values_at("name", "type") }.to_h
        end

        def columns
          schema.keys()
        end

        def to_sql(val)
          case val
          when Numeric
            val.to_s
          when String
            "'#{val}'"
          else
            raise "Can't change #{val.class} to SQL"
          end
        end

        def create(values)
          values.delete "id"

          keys = columns - ["id"]

          vals = keys.map do |key|
            values[key] ? to_sql(values[key]) : "null"
          end

          DB.execute insert_query_for(keys, vals)

          data = Hash[keys.zip vals]
          sql = "SELECT last_insert_rowid();"

          data["id"] = DB.execute sql

          new data
        end

        def insert_query_for(keys, values)
          <<~SQL.strip
            INSERT INTO #{table} (#{keys.join ','})
            VALUES (#{values.join ','});
          SQL
        end

        def count
           DB.execute(count_query)[0][0]
        end

        def count_query
          <<~SQL.strip
            SELECT COUNT(*) FROM #{table}
          SQL
        end

        def find(id)
          row = DB.execute <<~SQL.strip
            SELECT #{columns.join(',')} from #{table}
            WHERE id = #{id};
          SQL

          data = Hash[columns.zip row[0]]

          new data
        end

        def first
          row = DB.execute <<~SQL.strip
            SELECT #{columns.join(',')} from #{table} ORDER BY id ASC LIMIT 1;
          SQL

          data = Hash[columns.zip row[0]]

          new data
        end

        def last
          row = DB.execute <<~SQL.strip
            SELECT #{columns.join(',')} from #{table} ORDER BY id DESC LIMIT 1;
          SQL

          data = Hash[columns.zip row[0]]

          new data
        end

        def all
          rows = DB.execute <<~SQL.strip
            SELECT #{columns.join(',')} from #{table} ORDER BY id ASC;
          SQL

          rows.map { |row| new(Hash[columns.zip row]) }
        end
      end
    end
  end
end