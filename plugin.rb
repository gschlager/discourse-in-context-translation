# frozen_string_literal: true

# name: discourse-in-context-translation
# about: Allows in-context translation of Discourse using Crowdin.
# version: 1.0

register_locale("en_IC", name: "In-Context Translation", nativeName: "In-Context Translation", fallbackLocale: "en")
register_asset "javascripts/crowdin.js"

after_initialize do
  CROWDIN_JS_URL = "https://cdn.crowdin.com/jipt/jipt.js"

  def add_before_head_html
    <<~HTML
      <script type="text/javascript" src="#{CROWDIN_JS_URL}"></script>
    HTML
  end

  register_html_builder("server:before-head-close-crawler") { add_before_head_html }
  register_html_builder("server:before-head-close") { add_before_head_html }
  register_html_builder("wizard:head") { add_before_head_html }

  extend_content_security_policy(
    script_src: [CROWDIN_JS_URL, "unsafe-eval"]
  )

  # It's not really hidden, but this prevents changing the default_locale anyway.
  # That's good enough for now.
  SiteSetting.hidden_settings.concat([:default_locale])
  SiteSetting.default_locale = "en_IC"
end
