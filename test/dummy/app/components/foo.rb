class Foo < Netzke::Base
  def configure(c)
    super
    c.title = 'Test component'
  end
end
