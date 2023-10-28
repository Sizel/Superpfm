class ApplicationController < ActionController::Base
  def one; end

  def two; end

  def self.three
    four
  end
end
