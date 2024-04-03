class Object
  def self.const_missing(c)
    return nil if @prevent_infinity_loop

    @prevent_infinity_loop = true

    begin
      require c.to_s.downcase
    rescue LoadError => e
      require Amy.to_snake_case(c.to_s)
      klass = Object.const_get(c)
    end

    @prevent_infinity_loop = false

    klass
  end
end