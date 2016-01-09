require "rails_helper"

class PathableModel < FauxModel
  include Pathable

  define_attributes :name, :path, :other
end

RSpec.describe Pathable do

  VALID_NAME = "A Pathable Name"
  VALID_PATH = "a_pathable_name"

  LONG_NAME = "A Really, " + ("Really, " * 100) + "Name"
  LONG_PATH = "a_really_" + ("really_" * 100) + "name"

  SHORT_PATH = "a"

  ILLEGAL_PATH = "A path with really bad ##### values"

  before :example do
    @pm = PathableModel.new
  end

  context "when generating a path" do

    it "converts blanks to underscores and uppercase to lowercase" do
      expect(PathableModel.generate_path(VALID_NAME)).to eq(VALID_PATH)
    end

  end

  context "when validating" do

    it "only validates name and path" do
      @pm.name = VALID_NAME
      @pm.path = VALID_PATH
      expect(@pm).to be_valid
      expect(@pm.errors).to be_empty
    end

    it "will generate the path from the name" do
      @pm.name = VALID_NAME
      expect(@pm).to be_valid
      expect(@pm.path).to_not be_empty
    end

    it "requires that the name is present" do
      @pm.path = VALID_PATH
      expect(@pm).to_not be_valid
      expect(@pm.errors).to have_key(:name)
    end

    it "limits the name to 255 characters" do
      @pm.name = LONG_NAME
      @pm.path = VALID_PATH
      expect(@pm).to_not be_valid
      expect(@pm.errors).to have_key(:name)
    end

    it "requires that the path is present" do
      expect(@pm).to_not be_valid
      expect(@pm.errors).to have_key(:path)
    end

    it "requires the path to be at least two characters" do
      @pm.name = VALID_NAME
      @pm.path = SHORT_PATH
      expect(@pm).to_not be_valid
      expect(@pm.errors).to have_key(:path)
    end

    it "limits the path to 255 characters" do
      @pm.name = VALID_NAME
      @pm.path = LONG_PATH
      expect(@pm).to_not be_valid
      expect(@pm.errors).to have_key(:path)
    end
  
  end

end
