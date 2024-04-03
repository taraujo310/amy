class Object
  def self.const_missing(c)
    return nil if @prevent_infinity_loop

    @prevent_infinity_loop = true

    require Amy.to_snake_case(c.to_s)
    klass = Object.const_get(c)

    @prevent_infinity_loop = false

    klass
  end
end