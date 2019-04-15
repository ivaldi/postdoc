module PostdocViewHelper
  def postdoc_stylesheet_link_tag(*path)
    content_tag :style, File.read(
          Rails.root.join('app', 'assets', 'stylesheets', *path)
        ).html_safe,
        type: 'text/css'
  end

  protected

  # include an assets from the gem app/assets folder
  def postdoc_gem_asset(*path)
    File.join(File.dirname(__FILE__), '..', '..', 'app', 'assets', *path)
  end
end
