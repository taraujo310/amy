require "multi_json"

module Amy
  module Model
    class FileModel
      attr_reader :id

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

        def create(attrs)
          hash = {
            "submitter" => attrs["submitter"] || "",
            "quote" => attrs["quote"] || "",
            "attribution" => attrs["attribution"] || ""
          }

          files = Dir["db/quotes/*.json"]
          names = files.map { |f| f.split("/")[-1] }
          highest = names.map { |basename| basename[0...-5].to_i }.max
          id = highest + 1

          File.open("db/quotes/#{id}.json", "w") do |f|
            schema = <<~TEMPLATE
            {
              "submitter": "#{hash["submitter"]}",
              "quote": "#{hash["quote"]}",
              "attribution": "#{hash["attribution"]}"
            }
            TEMPLATE

            f.write schema
          end

          FileModel.new "db/quotes/#{id}.json"
        end
      end
    end
  end
end