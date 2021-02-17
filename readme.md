## Welcome to Postdoc.
This gem was build to convert HTML data into PDF documents. This is handy because Rails is much better at building HTML document than at building PDF documents.

## Usage

Add the following line to your gemfile
```ruby
gem 'postdoc'
```
And install it
```sh
bundle install
```

Now you can render a pdf from a string that contains the data from a HTML file in the following way:



## Handy links:
- [ChromeRemote](https://github.com/cavalle/chrome_remote) is gives us a client to talk to chrome.

## Handy commands:
```sh
  # Run tests.
  rake test

  # Generate a test pdf. Usefull for debugging purposes.
  bin/run_with_website
```

## Known issues:

For Mac users with an `No such file or directory - chrome` exception, use the following command from the root folder of this repository.

```
cp bin/chrome /usr/local/bin/chrome
```
