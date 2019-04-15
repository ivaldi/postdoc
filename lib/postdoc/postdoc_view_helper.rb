module PostdocViewHelper
  def postdoc_stylesheet_link_tag(path)
    content_tag :style, read_asset(path), type: 'text/css'
  end

  def postdoc_javascript_include_tag(path)
    content_tag :script, read_asset(path), type: 'text/javascript'
  end

  def postdoc_image_tag(path, options = {})
    image_tag asset_path(path), options
  end

  protected

  def read_asset(path)
    Rails.application.assets.find_asset(path).to_s.html_safe
  end

  def asset_path(path)
    Rails.application.assets.find_asset(path).filename
  end
end
