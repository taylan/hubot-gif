# hubot-gif

Hubot script which can search for gifs on imgur or get random reaction gifs from reactiongifsarchive.imgur.com

See [`src/gif.coffee`](src/gif.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-gif --save`

Then add **hubot-gif** to your `external-scripts.json`:

```json
[
  "hubot-gif"
]
```

## Configuration

You need to set the `HUBOT_IMGUR_CLIENT_ID` environment variable which can be obtained from https://api.imgur.com/oauth2/addclient

## Sample Interaction

```
user1>> hubot react categories
hubot>> Reaction categories are: abandon, childfail, clap, coolstory, dance, dealwithit, didntread, disgust, downvote, excited, feels, fu, haters, laugh, mindblown, nofucks, nope, notbad, party, popcorn, racist, sad, shutup, skill, sports, upvote, wut

user1>> hubot react with notbad
hubot>> http://i.imgur.com/LKSQW4D.gifv

user1>> hubot gif me shia labeouf do it
hubot>> http://i.imgur.com/NWmdMk0.gifv
```
