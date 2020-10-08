# frozen_string_literal: true

# name: discourse-in-context-translation
# about: Allows in-context translation of Discourse using Crowdin.
# version: 1.0

register_locale("en_IC", name: "In-Context Translation", nativeName: "In-Context Translation", fallbackLocale: "en")

after_initialize do
  def add_before_head_html
    <<~HTML
      <script type="text/javascript">
          var _jipt = [];
          _jipt.push(['project', 'f3230e7607a36bb0a2f97fd90605a44e']);
          _jipt.push(['domain', 'discourse']);
      </script>
      <script type="text/javascript" src="//cdn.crowdin.com/jipt/jipt.js"></script>
    HTML
  end

  register_html_builder('server:before-head-close-crawler') do
    add_before_head_html
  end

  register_html_builder('server:before-head-close') do
    add_before_head_html
  end

  # It's not really hidden, but this prevents changing the default_locale anyway.
  # That's good enough for now.
  SiteSetting.hidden_settings.concat([:default_locale])
  SiteSetting.default_locale = "en_IC"
end
