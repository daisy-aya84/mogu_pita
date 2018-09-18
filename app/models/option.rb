class Option < ApplicationRecord
  require 'fileutils'
  def dir_delete
    FileUtils.rm_rf("public/foods/#{self.id}")
  end
end
