module Postdoc
  # Different prints require different settings. This class is used instead of
  # passing options arguments throughout all of the code.
  class PrintSettings
    def initialize(
        header_template: '',
        footer_template: '',
        landscape: false,
        print_background: true,
        margin_top: 1,
        margin_bottom: 1,
        margin_left: 1,
        margin_right: 1
    )
      @header_template = header_template
      @footer_template = footer_template
      @landscape = landscape
      @print_background = print_background
      @margin_top = margin_top
      @margin_bottom = margin_bottom
      @margin_left = margin_left
      @margin_right = margin_right
    end

    def to_cmd
      { landscape: @landscape,
        printBackground: true,
        marginTop: @margin_top,
        marginBottom: @margin_bottom,
        marginLeft: @margin_left,
        marginRight: @margin_right,
        displayHeaderFooter: display_header_and_footer?,
        headerTemplate: @header_template,
        footerTemplate: @footer_template }
    end

    private

    def display_header_and_footer?
      @header_template.present? || @footer_template.present?
    end
  end
end
