status_accessor
===============

A simple bit of code we keep reusing.

It provides a quick way of setting up accessors for a status-like field

Examples
--------

```ruby
status_accessor :open, :closed
```

is equivalent to

@@status_strings = ['OPEN', 'CLOSED']

```ruby
def open?
  status == 'OPEN'
end
```

def open!
  status = 'OPEN'
end

def closed?
  status == 'CLOSED'
end

def closed!
  status = 'CLOSED'
end

 also adds appropriate named_scope accessors

# named_scope :open, :conditions => {:status => 'OPEN'}
# named_scope :closed, :conditions => {:status => 'CLOSED'}

# an alternative field name can also be specified to override the default fieldname of 'status' like this:

# status_accessor :foo, [:open, :closed]

# which works as expected so
# obj.open!
# obj.foo
# => 'OPEN'

# Obj.foo_strings
# => ['OPEN', 'CLOSED']

# by default statuses are stored upcase.  This behaviour can be modified by passing a :transform option eg

# status_accessor :open, :closed, :transform => :downcase
#
# then
# obj.open!
# obj.status
#> 'open'

