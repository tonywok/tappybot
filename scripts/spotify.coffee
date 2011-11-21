#   Control Spotify on OSX   #

sh      = require 'sh'
spotify = require 'spotify'
_       = require 'underscore'

columbus_peeps = [
  202413 # objo
  204770 # Jerry Nümmi
  204783 # Ken Barker
  234066 # Adam McCrea
  363421 # Matt Yoho
  387812 # Monica McJunkin
  418484 # Mike Doel
  425350 # Marc Peabody
  425424 # Leon Gersing
  626205 # Shelley Byers
  633892 # Felix Flores
  647738 # John Andrews
  663534 # Tony Schneider
  675130 # Mike Enriquez
  714820 # Dan Windle
  829907 # Aaron Christy
  845864 # Justine Arriba!
  845866 # Andrew Grieser
  872395 # Scott Walker
  935211 # Tyler Wymer
  1012125 # Matt Jones
  1028915 # Matthew Boston
  1040480 # Tappy
]

authorized = (msg) ->
  _.include columbus_peeps, msg.message.user.id

module.exports = (robot) ->
  # show commands

  options = {}
  options.commands = [
    "play <1|2|3|query> - Play/pause, play a song that you searched (1,2,3) or play a track by title",
    "pause - Pause the current song",
    "toggle - Play/pause the current song",
    "stop - Stop current song",
    "next - Play the next song from the playlist",
    "previous - Play the previous song from the playlist",
    "current song - Shows what song I'm currently playing",
    "volume <0..9|up|down> - Change volume using a specific number between 0 (mute) and 9 or by up and down",
    "mute - Mute/unmute the sound",
    "search <track|album|artist> <query> - Search for a track on Spotify and play it"
  ]

  # starting volume in spotify
  options.volume = 100

  robot.respond /spotify$/i, (msg) ->
    msg.send options.commands.join("\n")

  # controls
  robot.respond /toggle$/i, (msg) ->
    return unless authorized(msg)
    msg.send "Okay, toggling play/pause in Spotify"
    sh('osascript -e \'tell app "Spotify" to playpause\'')

  robot.respond /play$/i, (msg) ->
    return unless authorized(msg)
    msg.send "Playing the current song in Spotify"
    sh('osascript -e \'tell app "Spotify" to playpause\'')

  robot.respond /(pause|stop)$/i, (msg) ->
    return unless authorized(msg)
    msg.send "Pausing the current song in Spotify"
    sh('osascript -e \'tell app "Spotify" to playpause\'')

  robot.respond /(next|play next|play the next song)$/i, (msg) ->
    return unless authorized(msg)
    sh('osascript -e \'tell app "Spotify" to next track\'')
    song = sh('osascript src/scripts/current_song.scpt')
    song.result (obj) ->
      msg.send "And now I'm playing "+ obj

  robot.respond /(previous|prev|play previous|play the previous song)$/i, (msg) ->
    return unless authorized(msg)
    sh('osascript -e \'tell app "Spotify" to previous track\'')
    song = sh('osascript src/scripts/current_song.scpt')
    song.result (obj) ->
      msg.send "Playing this song again: "+ obj

  robot.respond /volume ((\d{1,2})|up|down)$/i, (msg) ->
    return unless authorized(msg)
    volume = msg.match[1]

    switch volume
      when "up"
        if options.volume < 100
          options.volume+=10
          msg.send "Louder, louder!"
      when "down"
        if options.volume > 0
          options.volume-=10
          msg.send "Ah, I was trying to say it, but nobody could hear me. Oh wait, I don't have a voice"
      else
        if volume < (options.volume/10)
          msg.send "Yes, this is too loud for me"
        else
          msg.send "Turning up the volume! w00t"
        options.volume = Math.round(volume)*10 if volume <= 100

    sh('osascript -e \'tell application "Spotify" to set sound volume to '+options.volume+'\'')

  robot.respond /mute$/i, (msg) ->
    return unless authorized(msg)
    if options.muted
      sh('osascript -e \'tell application "Spotify" to set sound volume to '+options.volume+'\'')
      msg.send "That was a quiet moment"
    else
      sh('osascript -e \'tell application "Spotify" to set sound volume to 0\'')
      msg.send "Silence"
    options.muted = !options.muted

  robot.respond /unmute$/i, (msg) ->
    return unless authorized(msg)
    if options.muted
      sh('osascript -e \'tell application "Spotify" to set sound volume to '+options.volume+'\'')
      msg.send "That was a quiet moment"

  # show what song I'm currently playing
  robot.respond /(current|song|track|current song|current track)$/i, (msg) ->
    song = sh('osascript src/scripts/current_song.scpt')
    song.result (obj) ->
      msg.send "The current song I'm playing is "+ obj

  # search through Spotify
  robot.respond /search ?(track|song|album|artist)? (.*)$/i, (msg) ->
    query = msg.match[2]

    if msg.match[1]?
      switch msg.match[1]
        when "track" or "song" then type = "track"
        when "album" then type = "album"
        when "artist" then type = "artist"
    else
      type = "track"

    spotify.search
      type: type
      query: query
      (err, data) ->
        unless err
          switch type
            when "track"
              if data.tracks.length is 1
                song = data.tracks[0]
                msg.send "Found it.. use Hubot play 1 for “"+song.name+"” by "+song.artists[0].name
                options.result = {first: data.tracks[0].href}
              else if data.tracks.length is 2
                result = [
                  "Use Hubot play 1 for “"+data.tracks[0].name+"” by "+data.tracks[0].artists[0].name,
                  "or use Hubot play 2 for “"+data.tracks[1].name+"” by "+data.tracks[1].artists[0].name
                ]
                msg.send result.join("\n")
                options.result = {first: data.tracks[0].href, second: data.tracks[1].href}
              else if data.tracks.length > 2
                result = [
                  "Use Hubot play 1 for “"+data.tracks[0].name+"” by "+data.tracks[0].artists[0].name,
                  "or use Hubot play 2 for “"+data.tracks[1].name+"” by "+data.tracks[1].artists[0].name,
                  "or play 3 for “"+data.tracks[2].name+"” by "+data.tracks[2].artists[0].name
                ]
                msg.send result.join("\n")
                options.result = {first: data.tracks[0].href, second: data.tracks[1].href, third: data.tracks[2].href}

            # can't play a song by album or artist at this moment... maybe in the feature
            when "album"
              album = data.albums[0]
              if album
                msg.send "Found a album by the name of "+album.name+". Now, to continue this quiz... Can you name a song?"
            when "artist"
              artist = data.artists[0]
              if artist
                msg.send "Got it. I found "+artist.name+". Now, to continue this quiz... Can you name a song?"

  # play a track or add a searched song to the play queue and play it
  robot.respond /play (.*)$/i, (msg) ->
    return unless authorized(msg)
    query = msg.match[1]
    switch query
      when "1"
        msg.send "Okay, sure why not"
        sh('open '+options.result.first) if options.result? and options.result.first?
      when "2"
        msg.send "Hah, this is my favorite song"
        sh('open '+options.result.second) if options.result? and options.result.second?
      when "3"
        msg.send "Are you really sure? Okay, I'll play it anyway"
        sh('open '+options.result.third) if options.third? and options.result.third?
      else
        spotify.search
          type: "track"
          query: msg.match[1]
          (err, data) ->
            unless err
              song = data.tracks[0]
              if song
                sh('open '+song.href)
                msg.send "Found it, playing: “"+song.name+"” by "+song.artists[0].name+" from "+song.album.name
