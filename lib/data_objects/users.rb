module Main
  class Users < DataObjects
    def initialize(pipe = nil)
      @attribute_groups = AttributeGroups.new(
        list_for_admin: [:name, :name, :surname],
        details_for_registered: [:name, :surname, :type],
        for_update: [:id, :name, :surname],
        for_create: [:name, :surname, :username, :password],
        for_login: [:username, :password, :type],
      )
      super pipe
    end

    def class_abbreviation
      "U"
    end
  end
end
