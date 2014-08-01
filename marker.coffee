# Class for the markers
class Marker
  constructor: (@id, @latlng) ->
    @start = null
    @end = null
    @glatlng = { lat: @latlng.latitude, lng: @latlng.longitude }
    @icon = "vitaliikalinincrg/map-test//states/inactive.png"
    @prevIcon = "vitaliikalinincrg/map-test//states/inactive.png"
    @showWindow = false
