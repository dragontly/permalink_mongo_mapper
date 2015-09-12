# permalink_mongo_mapper
Make permalink use with mongo_mapper
How to use
#use in mongo mapper
gem 'permalink_mongo_mapper'

class Category
	include MongoMapper::Document
	include Permalink
	key :name, String
	has_permalink :name
end

#get it

<%= link_to @category.name,category_path(@category.permalink) %>
