Trimmer Controller
=================

Rack endpoint to make templates and i18n translations available in javascript.

See specs for more details.

How it works
------------

Trimmer adds additional routes to your app:

- /trimmer/en.js
- /trimmer/es.js
- etc

This defines two variables in your app: I18n.translations and Templates.

Translations
------------

Trimmer will serve the translations you define from your config/locales files available as a JS object.

Templates
---------

This is the cool part. You can define your own structure of client-side templates which will be:

1. Rendered by Rails (where you can access ERB, helpers and Rails i18n)
2. Available in JS as templates

To add templates, create a folder structure like this:

    app/
      templates/
        users/
          index.jade.erb
          show.jade.erb
        settings.jade.erb

This will create a JS object with this structure:

    Templates = {
      users: {
        index: "...",
        show: "..."
      },
      settings: "..."
    }


          
          


