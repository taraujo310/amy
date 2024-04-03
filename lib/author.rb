module Amy
  class Author
    attr_accessor :name, :email, :github

    def initialize(args)
      @name = args[:name]
      @email = args[:email]
      @github = args[:github]
    end

    def to_s
      "Application developed by #{name} \n" +
      "You can contact him at #{email} \n" +
      "Or view the github profile: #{github}\n\n"
    end
  end
end