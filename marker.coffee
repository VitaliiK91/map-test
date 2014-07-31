class Marker
  constructor: (@id, @latitude, @longitude) ->
    @start = null
    @end = null
    @icon = "/states/inactive.png"
    @prevIcon = "/states/inactive.png"
    @showWindow = false
