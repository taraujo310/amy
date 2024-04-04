# frozen_string_literal: true

class Object
  def self.const_missing(c)
    return nil if @prevent_infinity_loop

    @prevent_infinity_loop = true

    begin
      require c.to_s.downcase
    rescue LoadError
      require Amy.to_snake_case(c.to_s)
    end

    @prevent_infinity_loop = false

    Object.const_get(c)
  end
end
