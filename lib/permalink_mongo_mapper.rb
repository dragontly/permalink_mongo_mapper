# coding: utf-8
module Permalink
  def self.included(model)
    class << model
      attr_accessor :source_key
    end

    model.class_eval do
      model.extend( ClassMethods )
    end
  end

  module ClassMethods
    def has_permalink(source_key_param)
      key :permalink, String
      before_validation :create_permalink
      send :include, InstanceMethods

      self.source_key = source_key_param
    end

  end

  module InstanceMethods

    private
    def create_permalink
      self.permalink = String.new(read_attribute(self.class.source_key)) || ""
      remove_special_chars
      random_permalink if permalink.blank?
      create_unique_permalink
    end

    def remove_special_chars
      permalink.gsub!(/[áàảãạAÁÀẢÃẠ]/, 'a')
      permalink.gsub!(/[ăắẵằẳặĂẮẰẲẴẶ]/, 'a')
      permalink.gsub!(/[âấầẩẫậÂẤẦẨẪẬ]/, 'a')
      permalink.gsub!(/[éèẽẻẹÉÈẺẼẸ]/, 'e')
      permalink.gsub!(/[êếềểễệÊẾỀỂỄỆ]/, 'e')
      permalink.gsub!(/[íìỉĩịIÍÌỈĨỊ]/, 'i')
      permalink.gsub!(/[óòỏõọOÓÒỎÕỌ]/, 'o')
      permalink.gsub!(/[ôốồổỗộÔỐỒỔỖỘ]/, 'o')
      permalink.gsub!(/[ơớờởỡợƠỚỜỞỠỢ]/, 'o')
      permalink.gsub!(/[úùủũụUÚÙỦŨỤ]/, 'u')
      permalink.gsub!(/[ưứừửữựƯỨỪỬỮỰ]/, 'u')
      permalink.gsub!(/[ỷỹýỳ]/, 'y')
      permalink.gsub!(/[đĐ]/, 'd')
      permalink.gsub!(/[àáâãäå]/i,'a')
      permalink.gsub!(/[èéêë]/i,'e')
      permalink.gsub!(/[íìîï]/i,'i')
      permalink.gsub!(/[óòôöõ]/i,'o')
      permalink.gsub!(/[úùûü]/i,'u')
      permalink.gsub!(/æ/i,'ae')
      permalink.gsub!(/ç/i, 'c')
      permalink.gsub!(/ñ/i, 'n')
      permalink.gsub!(/[^\x00-\x7F]+/, '') # Remove anything non-ASCII entirely (e.g. diacritics).
      permalink.gsub!(/[^\w_ \-]+/i, '') # Remove unwanted chars.
      permalink.gsub!(/[ \-]+/i, '-') # No more than one of the separator in a row.
      permalink.gsub!(/^\-|\-$/i, '') # Remove leading/trailing separator.
      permalink.downcase!
    end

    def create_unique_permalink
      permalink_src = permalink
      i = 1
      while is_unique(permalink_src)==false do
        permalink_src = permalink+i.to_s
        i = i+1
      end
      self.permalink = permalink_src
    end

    def random_permalink
      #self.permalink = Digest::SHA1.hexdigest("#{Time.now}")
      self.permalink = Time.now.to_s
    end

    def is_unique(current_permalink)
      self.class.find_by_permalink(current_permalink)==self || self.class.find_by_permalink(current_permalink)==nil
    end
  end
end
