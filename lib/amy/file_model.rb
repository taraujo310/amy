require "multi_json"

module Amy
  module Model
    class FileModel
      def initialize(filename)
        @filename = filename

        basename = File.split(filename)[-1]
        @id = File.basename(basename, ".json").to_i

        obj = File.read(filename)
        @hash = MultiJson.load(obj)
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      class << self
        def find(id)
          begin
            FileModel.new("db/quotes/#{id}.json")
          rescue
            return nil
          end
        end

        def all
          begin
            files = Dir["db/quotes/*.json"]
            files.map { |f| FileModel.new(f) }
          rescue => e
            return []
          end
        end
      end
    end
  end
end