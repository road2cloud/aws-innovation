import camelcase

def my_function(country = "norway"):
  c = camelcase.CamelCase()
  print(c.hump(country))

my_function("sweden")
my_function("india")
my_function()
my_function("brazil")
