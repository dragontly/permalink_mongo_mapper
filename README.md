How to use

#use in mongo mapper
#in Gemfile
gem 'permalink_mongo_mapper'

#in model class
```shell
include Permalink
key :name, String
has_permalink :name

```
#get it

<%= link_to @category.name,category_path(@category.permalink) %>
