class TestClassSuffix
  include Mongoid::Document
  include Mongoid::EnumAttribute

  enum :status, %i(awaiting_approval approved banned), suffix: true
  enum :roles, %i(author editor admin), multiple: true, default: [], required: false, suffix: "suffixed"
end
