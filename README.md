# Settr
This project is not ready for productive usage yet.

## Table of contents
* [Installation] (#installation)
* [Usage] (#usage)
* [License] (#license)

## Installation
Add the gem to your `Gemfile`.
```ruby
  gem settr, github: 'metaminded/settr'
```

Afterwards you have to run these commands on the command line.
```
  bundle install
  rake settr:install:migrations
```

## Usage
Create `config/initializers/settings.rb` and add your settings to it, like:
```ruby
  Setting.find_or_create_by! key: 'title' do |s|
    s.kind = 'string'
  end
  Setting.find_or_create_by! key: 'default_factor' do |s|
    s.kind = 'integer'
  end
```

Now you can create a form.
I will use [simple_form](https://github.com/plataformatec/simple_form) in this example and slim for better readability.

```ruby
  settings = Settings.new
  settings.setting_model = Setting

  = simple_form_for settings, url: settings_path, method: :post do |f|
    = f.input :title
    = f.input :default_factor
    = f.button :submit
```

### Available kinds
* boolean
* float
* integer
* string

## License
This project rocks and uses MIT-LICENSE.
