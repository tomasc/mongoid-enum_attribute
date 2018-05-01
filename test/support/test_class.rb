class TestClass
  include Mongoid::Document
  include Mongoid::EnumAttribute

  enum :status, %i(awaiting_approval approved banned)
  enum :roles, %i(author editor admin), multiple: true, default: [], required: false
end
