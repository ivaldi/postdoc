class PagesController < ApplicationController
  def show
    render pdf: 'show',
        header_template: File.read(Rails.root.join('app', 'views', 'pages', 'header.html')),
        footer_template: File.read(Rails.root.join('app', 'views', 'pages', 'footer.html'))
  end
end
