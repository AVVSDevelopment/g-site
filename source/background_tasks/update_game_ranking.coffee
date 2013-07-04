

This repository
Explore
Gist
Blog
Help
kpa6
 Unwatch
Star 0Fork 0PUBLIC AVVSDevelopment/g-site
 branch: master  g-site / source / background_tasks / update_game_analytics.coffee 
 AVVS a day ago final version: ga updater
1 contributor
 file 145 lines (116 sloc) 4.314 kb EditRawBlameHistory Delete
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
53
54
55
56
57
58
59
60
61
62
63
64
65
66
67
68
69
70
71
72
73
74
75
76
77
78
79
80
81
82
83
84
85
86
87
88
89
90
91
92
93
94
95
96
97
98
99
100
101
102
103
104
105
106
107
108
109
110
111
112
113
114
115
116
117
118
119
120
121
122
123
124
125
126
127
128
129
130
131
132
133
134
135
136
137
138
139
140
141
142
143
144
145
###
  Env variables
###

process.env.GA_SERVICE_ACCOUNT      = process.env.GA_SERVICE_ACCOUNT      || "901556670104.apps.googleusercontent.com"
process.env.GA_SERVICE_EMAIL        = process.env.GA_SERVICE_EMAIL        || "901556670104@developer.gserviceaccount.com"
process.env.GA_KEY_PATH             = process.env.GA_KEY_PATH             || "source/gsites-analytics-privatekey.pem"
process.env.MONGOLAB_URI            = process.env.MONGOLAB_URI            || "mongodb://gsite_app:temp_passw0rd@ds041327.mongolab.com:41327/heroku_app14575890"

###
  Modules
###

_ = require 'underscore'
fs = require 'fs'
path = require 'path'
crypto = require 'crypto'
request = require 'request'
qs = require 'querystring'
googleapis = require 'googleapis'
mongoose = require 'mongoose'
async = require 'async'

###
  Models we use
###
gamesM    = require("../models/games").model
sitesM    = require("../models/sites").model

authorize = (callback)->
  now = parseInt Date.now() / 1000, 10

  authHeader =
    alg: 'RS256'
    typ: 'JWT'

  authClaimSet =
    iss  : process.env.GA_SERVICE_EMAIL
    scope: 'https://www.googleapis.com/auth/analytics.readonly'
    aud  : 'https://accounts.google.com/o/oauth2/token'
    iat  : now
    exp  : now + 60

  #Setup JWT source
  signatureInput = base64Encode(authHeader) + '.' + base64Encode authClaimSet

  #Generate JWT
  cipher = crypto.createSign 'RSA-SHA256'
  cipher.update signatureInput
  signature = cipher.sign readPrivateKey(), 'base64'
  jwt = signatureInput + '.' + urlEscape signature

  #Send request to authorize this application
  request
    method: 'POST'
    headers:
      'Content-Type': 'application/x-www-form-urlencoded'
    uri: 'https://accounts.google.com/o/oauth2/token'
    body: 'grant_type=' + escape('urn:ietf:params:oauth:grant-type:jwt-bearer') +
    '&assertion=' + jwt
  , (err, res, body)=>
    return callback err if err?

    # parsing JSON
    try
      gaResult = JSON.parse body
      throw gaResult.error if gaResult.error?
    catch error
      return callback error

    callback null, gaResult

urlEscape = (source)->
  source.replace(/\+/g, '-').replace(/\//g, '_').replace /\=+$/, ''

base64Encode = (obj)->
  encoded = new Buffer(JSON.stringify(obj), 'utf8').toString 'base64'
  urlEscape encoded

readPrivateKey = ->
  fs.readFileSync process.env.GA_KEY_PATH, 'utf8'

process_analytics_data = (data, callback)->
  sitesM.find {}, (err, sites)->
    return callback err if err?
    sitesByDomain = {}
    sites.forEach (site)-> sitesByDomain[site.domain] = site

    #console.log sitesByDomain

    async.forEach data, (details, done)->
      [gameSpecificDomain, gameSpecificSlug, pageviews, avg_time, bounce_rate] = details
      # return unless its a game
      return done null unless /^\/games\/[a-z0-9_-]+$/i.test(gameSpecificSlug)

      domainName = gameSpecificDomain.replace "www.",""
      siteId = sitesByDomain[domainName]._id

      extractedSlug = gameSpecificSlug.replace "/games/", ""

      #console.log siteId, extractedSlug

      gamesM.update {site: siteId, slug: extractedSlug}, {pageviews, avg_time, bounce_rate}, (err)->
        console.log arguments
        done err

    , callback


update_game_analytics = (callback) ->
  authorize (err, data) ->
    return callback err if err?

    #Query the number of total visits for a month
    requestConfig =
      'ids': 'ga:73030585'
      'start-date': '2013-02-01'
      'end-date': '2013-07-04'
      'metrics': 'ga:timeOnPage,ga:avgTimeOnPage'
      'dimensions': 'ga:hostname,ga:pagePath'

    request
      method: 'GET'
      headers:
        'Authorization': 'Bearer ' + data.access_token
      uri: 'https://www.googleapis.com/analytics/v3/data/ga?' + qs.stringify requestConfig
    ,(err, res, body)->
      return callback err if err?
      try
        data = JSON.parse body
        throw data.error if data.error?
      catch error
        return callback error

      # get unique domains
      process_analytics_data data.rows, callback

exports.run = ->
  db = mongoose.connect process.env.MONGOLAB_URI, (err)->
    throw err if err?
    update_game_analytics (err, data)->
      throw err if err?
      console.info "successfuly updated information about the games"
      # closing mongoose connection
      mongoose.connection.close()
Status Developer Training Shop Blog About © 2013 GitHub, Inc. Terms Privacy Security Contact 