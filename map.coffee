class Marker
  constructor: (@id, @latitude, @longitude) ->
    @start = null
    @end = null
    @icon = "http://mapicons.nicolasmollet.com/wp-content/uploads/mapicons/shape-default/color-66c547/shapecolor-light/shadow-1/border-white/symbolstyle-dark/symbolshadowstyle-no/gradient-no/bridge_old.png"
    @showWindow = false

app = angular.module 'mapApp', ['google-maps', 'services']

app.controller 'infoController', ['$scope', 'sharedProperties', ($scope, sharedProperties) ->
  $scope.onStartClick = () ->
    sharedProperties.setStart($scope.model.id)
    
  $scope.onEndClick = () ->
    sharedProperties.setEnd($scope.model.id)
]

app.controller 'mapController', ['$scope', 'sharedProperties',($scope, sharedProperties) ->
  $scope.markers = []
  
  $scope.map = {
    'center': {'latitude': 33.884388, 'longitude': -117.641235},
    'zoom': 12 
  }

  $scope.local = sharedProperties.Properties()

  $scope.logIt = -> console.log "Selected"

  $scope.prevIcon = ''

  $scope.showTraffic = false

  $scope.toggleTrafficLayer =  ->
    $scope.showTraffic = !$scope.showTraffic

  setMarkerToStart = (marker) ->
    marker.status = "start"
    marker.icon = $scope.local.markers[$scope.local.start].icon = "http://mapicons.nicolasmollet.com/wp-content/uploads/mapicons/shape-default/color-262626/shapecolor-white/shadow-1/border-color/symbolstyle-color/symbolshadowstyle-no/gradient-no/bridge_old.png"
    marker.prevIcon = $scope.local.markers[$scope.local.start].icon = "http://mapicons.nicolasmollet.com/wp-content/uploads/mapicons/shape-default/color-262626/shapecolor-white/shadow-1/border-color/symbolstyle-color/symbolshadowstyle-no/gradient-no/bridge_old.png"
  
  setMakerToInactive = (marker) ->
    marker.status = "inactive"
    marker.icon = "http://mapicons.nicolasmollet.com/wp-content/uploads/mapicons/shape-default/color-66c547/shapecolor-light/shadow-1/border-white/symbolstyle-dark/symbolshadowstyle-no/gradient-no/bridge_old.png"
    marker.prevIcon = "http://mapicons.nicolasmollet.com/wp-content/uploads/mapicons/shape-default/color-66c547/shapecolor-light/shadow-1/border-white/symbolstyle-dark/symbolshadowstyle-no/gradient-no/bridge_old.png"

  setMarkerToEnd = (marker) ->
    marker.status = "end"
    marker.icon = "http://mapicons.nicolasmollet.com/wp-content/uploads/mapicons/shape-default/color-262626/shapecolor-color/shadow-1/border-dark/symbolstyle-white/symbolshadowstyle-dark/gradient-no/bridge_old.png"
    marker.prevIcon = "http://mapicons.nicolasmollet.com/wp-content/uploads/mapicons/shape-default/color-262626/shapecolor-color/shadow-1/border-dark/symbolstyle-white/symbolshadowstyle-dark/gradient-no/bridge_old.png"
	
  latlngs = []

  latlngs.push {'latitude': 33.884780, 'longitude': -117.639754}
  latlngs.push {'latitude': 33.884388, 'longitude': -117.641235}
  latlngs.push {'latitude': 33.883924, 'longitude': -117.643724}
  
  latlngs.forEach (element, index) ->
    marker = new Marker index, element.latitude, element.longitude 
	
    marker.close = -> 
      @model.icon = $scope.prevIcon
      @model.showWindow = false
      $scope.$apply()
	  
    marker.onClick = ->
      $scope.prevIcon = @model.icon
      @model.icon = "http://mapicons.nicolasmollet.com/wp-content/uploads/mapicons/shape-default/color-facd1b/shapecolor-light/shadow-1/border-white/symbolstyle-dark/symbolshadowstyle-no/gradient-no/tollstation.png"
      $scope.local.markers.forEach (element) -> element.showWindow = false
      @model.showWindow = true
      $scope.id = @model.id
      $scope.$apply()
	  
    $scope.local.markers.push marker
  
  $scope.$watchGroup ['local.start', 'local.end'], (newValues, oldValues) ->
    startId = newValues[0].id 
    endId = newValues[1].id
    if (startId is -1) and (endId is -1)
      return
    markers = sharedProperties.Properties().markers
    markers.forEach (marker) ->
      setMakerToInactive(marker) if marker.status is "start" or marker.status is "end"
    sharedProperties.setMarkers markers
    setMakerToStart markers[startId]
    setMarkerToEnd markers[endId]    
]
