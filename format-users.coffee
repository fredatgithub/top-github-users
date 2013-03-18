fs = require 'fs'

stats2markdown = (datafile, mdfile, title) ->
  stats = require(datafile).slice(0, 500)

  today = new Date()
  from = new Date()
  from.setYear today.getFullYear() - 1

  out = """
  # Most active GitHub users ([git.io/top](http://git.io/top))

  The count of contributions (summary of Pull Requests, opened issues and commits) to public repos at GitHub.com from **#{from.toGMTString()}** till **#{today.toGMTString()}**.

  Only first 1000 GitHub users according to the count of followers are taken. Sorting algo in pseudocode:

  ```coffeescript
  githubUsers
    .filter((user) -> user.followers > 165)
    .sortBy('contributions')
    .slice(0, 500)
  ```

  Made with data mining of GitHub.com ([raw data](https://gist.github.com/4524946), [script](https://github.com/paulmillr/top-github-users)) by [@paulmillr](https://github.com/paulmillr) with contribs of [@lifesinger](https://githubcom/lifesinger). Updated every sunday.

  <table cellspacing="0"><thead>
  <th scope="col">#</th>
  <th scope="col">Username</th>
  <th scope="col">Contributions</th>
  <th scope="col">Language</th>
  <th scope="col">Location</th>
  <th scope="col" width="30"></th>
  </thead><tbody>\n
  """

  rows = stats.map (stat, index) ->
    """
    <tr>
      <th scope="row">##{index + 1}</th>
      <td><a href="https://github.com/#{stat.login}">#{stat.login}</a>#{if stat.name then ' (' + stat.name + ')' else ''}</td>
      <td>#{stat.contributions}</td>
      <td>#{stat.language}</td>
      <td>#{stat.location}</td>
      <td><img width="30" height="30" src="#{stat.gravatar.replace('?s=400', '?s=30')}"></td>
    </tr>
    """.replace(/\n/g, '')

  out += "#{rows.join('\n')}\n</tbody></table>"

  fs.writeFileSync mdfile, out
  console.log 'Saved to', mdfile

stats2markdown './raw/github-users-stats.json', './formatted/active.md'