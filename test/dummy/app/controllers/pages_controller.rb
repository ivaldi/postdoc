class PagesController < ApplicationController
  def show
    render pdf: 'show'
  end
end
