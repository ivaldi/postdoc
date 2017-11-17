module PostdocViewHelper
  def postdoc_default_styles
    content_tag :style,
        File.read(postdoc_gem_asset('stylesheets', 'default.css')),
        type: 'text/css'
  end

  protected

  def postdoc_gem_asset(*path)
    File.join(File.dirname(__FILE__), '..', '..', 'app', 'assets', *path)
  end
end
