status_accessor
===============

A simple bit of code we keep reusing.

It provides a quick way of setting up accessors for a status-like field,
which by default is called :status, but can be anything

Examples
--------

```ruby
status_accessor :open, :closed
```

is equivalent to

```ruby
@@status_strings = ['OPEN', 'CLOSED']

def open?
  status == 'OPEN'
end

def open!
  status = 'OPEN'
end

def closed?
  status == 'CLOSED'
end

def closed!
  status = 'CLOSED'
end

# also adds appropriate named_scope accessors if the class responds to
# named_scope (ie it is an ActiveRecord subclass)

named_scope :open, :conditions => {:status => 'OPEN'}
named_scope :closed, :conditions => {:status => 'CLOSED'}
```

An alternative field name can also be specified to override the default fieldname of 'status' like this:

```ruby
status_accessor :foo, [:open, :closed]
```

which works as expected so

```ruby
obj.open!
obj.foo
# => 'OPEN'

Obj.foo_strings
# => ['OPEN', 'CLOSED']
```

By default statuses are stored upcase.  This behaviour can be modified by passing a :transform option eg

```ruby
status_accessor :open, :closed, :transform => :downcase

# then
obj.open!
obj.status
# => 'open'
```
