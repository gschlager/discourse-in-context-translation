# frozen_string_literal: true

# name: discourse-in-context-translation
# about: Allows in-context translation of Discourse using Crowdin.
# version: 1.0

register_locale("en_IC", name: "In-Context Translation", nativeName: "In-Context Translation", fallbackLocale: "en")
register_asset "javascripts/crowdin.js"

CROWDIN_JS_URL = "https://cdn.crowdin.com/jipt/jipt.js"

def crowdin_js
  <<~HTML
      <script type="text/javascript" src="#{CROWDIN_JS_URL}"></script>
  HTML
end

register_html_builder("server:before-head-close-crawler") { crowdin_js }
register_html_builder("server:before-head-close") { crowdin_js }
register_html_builder("wizard:head") do |controller|
  <<~HTML
      #{controller.helpers.preload_script("plugins/discourse-in-context-translation")}
      #{crowdin_js}
  HTML
end

extend_content_security_policy(
  script_src: [CROWDIN_JS_URL, "unsafe-eval"]
)

after_initialize do
  # It's not really hidden, but this prevents changing the default_locale anyway.
  # That's good enough for now.
  SiteSetting.hidden_settings.concat([:default_locale])
  SiteSetting.default_locale = "en_IC"
end
