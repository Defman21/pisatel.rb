window.app = new Vue
  el: '#app'
  methods:
    setup: (event) ->
      event.preventDefault()
      event.stopPropagation()
      data = new FormData
      data.append 'json', JSON.stringify @selected
      
      fetch('/setup', {
        method: 'POST',
        body: data
      }).then((response) -> response.json()).then((data) =>
        if data.error?
          @result = data.error
        else
          @result = data.output + "\n Restart the server! :)"
      )
  data:
    result: "Waiting for output"
    defaults:
      adapter: 'sqlite'
    options:
      adapters: [
        'sqlite',
        'mysql2',
        'postgres'
      ]
    selected:
      adapter: 'sqlite'
      host: null
      port: null
      username: null
      password: null
      database: null
      db_file: null