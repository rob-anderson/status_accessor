# status_accessor :open, :closed
# is equivalent to

# @@status_strings = ['OPEN', 'CLOSED']

# def open?
#   status == 'OPEN'
# end
#
# def open!
#   status = 'OPEN'
# end
#
# def closed?
#   status == 'CLOSED'
# end
#
# def closed!
#   status = 'CLOSED'
# end

# also adds appropriate named_scope accessors

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

module StatusAccessor

  def status_accessor(*args)

    options = args.last.is_a?(Hash) ? args.pop : {}

    # if the second argument is an array, assume the first is an alternative field name
    if args[1].is_a?(Array)
      field_name, statuses = args

    # otherwise, assume all the agruments are statuses and default to field name 'status'
    else
      field_name = :status
      statuses = args
    end

    statuses.each do |s|
      state = options[:transform] ? s.to_s.send(options[:transform]) : s.to_s.upcase
      define_method("#{s.to_s.downcase}!") do
        self.send("#{field_name}=", state)
      end
      define_method("#{s.to_s.downcase}?") do
        self.send(field_name) == state
      end
      define_method("update_to_#{s.to_s.downcase}!") do
        self.update_attribute(field_name, state)
      end

      # in case we want to use this outside the context of ActiveRecord
      if self.respond_to?(:named_scope)
        named_scope s.to_s.downcase.to_sym, :conditions => {:"#{field_name}" => state}
      end

    end

    class_variable_set "@@#{field_name}_strings", statuses.collect {|s| s.to_s.upcase}

    (class << self; self; end).send(:define_method, "#{field_name}_strings") do
      class_variable_get "@@#{field_name}_strings"
    end

  end

end


