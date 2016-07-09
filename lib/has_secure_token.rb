require 'active_record'
module ActiveRecord
  module SecureToken
    extend ActiveSupport::Concern

    module ClassMethods

      def has_secure_token(attribute = :token)
        # Load securerandom only when has_secure_token is used.
        require 'active_support/core_ext/securerandom'
        define_method("regenerate_#{attribute}") { update_attributes attribute => self.class.generate_unique_secure_token }
        before_create { self.send("#{attribute}=", self.class.generate_unique_secure_token) unless self.send("#{attribute}?")}
      end

      def generate_unique_secure_token
        SecureRandom.base58(24).downcase
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::SecureToken)
