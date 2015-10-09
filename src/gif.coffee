# Description
#   Hubot script which can search for gifs on imgur or get random reaction gifs from reactiongifsarchive.imgur.com
#
# Dependencies:
#   "cheerio": "~0.19.0"
#
# Configuration:
#   HUBOT_IMGUR_CLIENT_ID - Obtained from https://api.imgur.com/oauth2/addclient
#
# Commands:
#   hubot gif (me) <query> - search imgur for gifs with the <query>
#   hubot react categories - list supported categories for reaction gifs
#   hubot react with <category> - get a random reaction gif from <category>

$ = require 'cheerio'
client_id = process.env.HUBOT_IMGUR_CLIENT_ID

reaction_categories = {
  "nope": "JNzjB",
  "abandon": "aYJkp",
  "disgust": "AXues",
  "excited": "1GOKT",
  "clap": "NzuZS",
  "shutup": "FGIfa",
  "sad": "qfkyX",
  "notbad": "LoNV2",
  "popcorn": "LPRbU",
  "haters": "yGacg",
  "didntread": "tVg8K",
  "mindblown": "FEnwc",
  "upvote": "fG58m",
  "downvote": "ixZeK",
  "wut": "ywmyw",
  "coolstory": "yIdY2",
  "dance": "wy22z",
  "fu": "zKaIL",
  "dealwithit": "K21Ft",
  "nofucks": "cB34U",
  "laugh": "s16Zv",
  "childfail": "Oc5Gp",
  "party": "ijrTZ",
  "sports": "iLm77",
  "racist": "D87EB",
  "feels": "SL6aO",
  "skill": "S3TNe"
}

random_choice = (arr) ->
  arr[Math.floor(Math.random() * arr.length)]

get_categories = () -> (category for own category of reaction_categories)

get_random_image = (msg, category) ->
  url = "https://api.imgur.com/3/album/#{reaction_categories[category]}"
  msg.http(url).headers('Authorization': "Client-ID #{client_id}").get() (err, res, body) ->
    if res.statusCode is 200
      link = random_choice(JSON.parse(body).data.images).link
      link = "#{link}v" if link[-1..-1] != 'v'
      msg.send link
    else
      console.error "error: #{url} returned #{res.statusCode}"

module.exports = (robot) ->
  robot.respond /react categories/i, (msg) ->
    msg.send("Reaction categories are: #{get_categories().sort().join(', ')}")

  robot.respond /react with (\w+)?/i, (msg) ->
    unless process.env.HUBOT_IMGUR_CLIENT_ID
      return msg.send "You must configure the HUBOT_IMGUR_CLIENT_ID environment variable to use reaction gifs."
    category = msg.match[1] || 'party'
    if category in get_categories()
      get_random_image(msg, category)
    else
      msg.send("category '#{category}' is not supported")
      get_random_image(msg, 'dealwithit')

  robot.respond /gif( me)? (.*)/i, (msg) ->
    query = msg.match[2] || null
    if query
      url = "https://imgur.com/search/score/all?q_type=anigif&q_all=#{query}"
      msg.http(url).get() (err, res, body) ->
        if res.statusCode is 200
          image_urls = []
          $(body).find('.cards .post a>img').each((i, elem) ->
            url = $(elem).attr('src')[..-6]
            image_urls.push("https:#{url}.gifv") if image_urls.length < 5)
          if image_urls
            msg.send random_choice(image_urls)
          else
            msg.send "no gifs found for #{query}"
        else
          msg.send "error: #{url} returned #{res.statusCode}"
    else
      msg.send "Search query is required for this command."
