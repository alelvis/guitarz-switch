class CurrencyInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options)
    input_options = input_html_options.merge({data: {autonumeric: true}})
    merged_input_options = merge_wrapper_options(input_options, wrapper_options)

    template.content_tag(:div, class: 'input-group') do
      template.concat span_currency_sign
      template.concat @builder.text_field(attribute_name, merged_input_options)
    end
  end

  def span_currency_sign
    template.content_tag(:span, class: 'input-group-addon') do
      template.concat '€'.html_safe
    end
  end
end
