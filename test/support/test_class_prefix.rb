class TestClassPrefix
  include Mongoid::Document
  include Mongoid::EnumAttribute

  enum :status, %i(awaiting_approval approved banned), prefix: true
  enum :roles, %i(author editor admin), multiple: true, default: [], required: false, prefix: "prefixed"
end
