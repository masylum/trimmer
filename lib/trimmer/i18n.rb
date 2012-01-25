require 'i18n'

module Trimmer
  module I18n

    def raise_all_exceptions(*args)
      raise args.first.to_exception
    end

    def with_exception_handler(tmp_exception_handler = nil)
      if tmp_exception_handler
        current_exception_handler = self.exception_handler
        self.exception_handler    = tmp_exception_handler
      end
      yield
    ensure
      self.exception_handler = current_exception_handler if tmp_exception_handler
    end

    def without_fallbacks
      current_translate_method = ::I18n.backend.method(:translate)
      ::I18n.backend.class.send(:define_method, 'translate', translate_without_fallbacks)
      yield
    ensure
      ::I18n.backend.class.send(:remove_method, 'translate')
    end

    # deep_merge by Stefan Rusterholz, see http://www.ruby-forum.com/topic/142809
    MERGER = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &MERGER) : v2 }

    # Exports translations from the I18n backend to a Hash
    # :locale. If specified, will dump only translations for the given locale.
    # :only. If specified, will dump only keys that match the pattern. "*.date"
    def to_hash options = {}
      options.reverse_merge!(:only => "*")

      if options[:only] == "*"
        data = translations
      else
        data = scoped_translations options[:only]
      end

      if options[:locale]
        data[options[:locale].to_sym]
      else
        data
      end
    end

    def scoped_translations(scopes) # :nodoc:
      result = {}

      [scopes].flatten.each do |scope|
        deep_merge! result, filter(translations, scope)
      end

      result
    end

    # Filter translations according to the specified scope.
    def filter(translations, scopes)
      scopes = scopes.split(".") if scopes.is_a?(String)
      scopes = scopes.clone
      scope = scopes.shift

      if scope == "*"
        results = {}
        translations.each do |scope, translations|
          tmp = scopes.empty? ? translations : filter(translations, scopes)
          results[scope.to_sym] = tmp unless tmp.nil?
        end
        return results
      elsif translations.has_key?(scope.to_sym)
        return {scope.to_sym => scopes.empty? ? translations[scope.to_sym] : filter(translations[scope.to_sym], scopes)}
      end
      nil
    end

    # Initialize and return translations
    def translations
      self.backend.instance_eval do
        init_translations unless initialized?
        translations
      end
    end

    def deep_merge!(target, hash) # :nodoc:
      target.merge!(hash, &MERGER)
    end

    private
      
      def translate_without_fallbacks
        method_name = RUBY_VERSION =~ /1\.9/ ? :translate : 'translate'
        ancestor_module_with_translate = (::I18n.backend.class.included_modules - [::I18n::Backend::Fallbacks]).select {|m| m.instance_methods(false).include?(method_name) rescue false}
        ancestor_module_with_translate.first.instance_method(method_name) rescue nil
      end
  end
end
