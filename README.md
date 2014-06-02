## Tumblr Image Geocoder

This script uses geodata eventually present in photos in a tumblr stream and creates a geojson file from that.

## Usage

1. [Create an API application at Tumblr](http://www.tumblr.com/oauth/register). Note the consumer key.
1. Clone this repo and cd into the directory.
1. Install dependencies by using bundler: $ bundle install

You need to set two environment variables: TUMBLR_API_KEY needs to be your consumer key. TUMBLR_NAME is the full domain name of your tumblr blog (for example: localhost.tumblr.com is mine.) you can do that using a wrapper script and export or you can set the ENV variables on the command line, like so:

    $ TUMBLR_API_KEY=FOOBAR TUMBLR_NAME=localhost.tumblr.com ruby fetch.rb
    
## Result

In the end, if all goes well, the script should save a file named <blog_name>.geojson. This is, surprisingly, a [geojson](http://geojson.org) file that contains a Point feature for each image the script was able to geocode. It contains a number of geodata properties for each image, such as the image url, the url of the tumblr post, the tags and, if existing, the image caption.

## Example

A simple example that should contain all currently geocoded images on [thingsonbikelanes](http://thingsonbikelanes.tumblr.com) is deployed at [pixelpoke.de/geotumblr](http://pixelpoke.de/geotumblr/).

## License

See [LICENSE](LICENSE) file.