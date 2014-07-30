app = angular.module 'mapApp', ['google-maps']

app.service 'sharedProperties', ->
  props = {
    start: -1,
    end: -1,
    markers: []
  }
  return {
    Properties: -> return props,
    setStart: (val) -> props.start = val,
    setEnd: (val) -> props.end = val,
    setMarkers: (val) -> props.markers = val
  }

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

  latlngs = []

  latlngs.push {'latitude': 33.884780, 'longitude': -117.639754}
  latlngs.push {'latitude': 33.884388, 'longitude': -117.641235}
  latlngs.push {'latitude': 33.883924, 'longitude': -117.643724}

  for latlng, i in latlngs
    marker = {}
    marker.start = null
    marker.end = null
    marker.latitude = latlng.latitude
    marker.longitude = latlng.longitude
    marker.id = i
    marker.status = 'inactive'
    marker.icon = "http://mapicons.nicolasmollet.com/wp-content/uploads/mapicons/shape-default/color-66c547/shapecolor-light/shadow-1/border-white/symbolstyle-dark/symbolshadowstyle-no/gradient-no/bridge_old.png"
    marker.showWindow = false
    marker.close = -> 
      @model.icon = $scope.prevIcon
      @model.showWindow = false
      $scope.$apply()
    marker.onClick = ->
      $scope.prevIcon = @model.icon
      @model.icon = "http://mapicons.nicolasmollet.com/wp-content/uploads/mapicons/shape-default/color-facd1b/shapecolor-light/shadow-1/border-white/symbolstyle-dark/symbolshadowstyle-no/gradient-no/tollstation.png"
      for markerr in $scope.local.markers
        markerr.showWindow = false
      @model.showWindow = true
      $scope.id = @model.id
      $scope.$apply()
    # $scope.markers.push marker
    $scope.local.markers.push marker
  
  $scope.$watch 'local.start', ->
    if $scope.local.start is -1
      return
    console.log "Start changed."
    markers = sharedProperties.Properties().markers
    for marker in markers
      if marker.status == "start"
        marker.icon = "http://mapicons.nicolasmollet.com/wp-content/uploads/mapicons/shape-default/color-66c547/shapecolor-light/shadow-1/border-white/symbolstyle-dark/symbolshadowstyle-no/gradient-no/bridge_old.png"
        marker.status = "inactive"
    sharedProperties.setMarkers = markers
    $scope.local.markers[$scope.local.start].status = "start"
    $scope.prevIcon = $scope.local.markers[$scope.local.start].icon = "http://mapicons.nicolasmollet.com/wp-content/uploads/mapicons/shape-default/color-262626/shapecolor-white/shadow-1/border-color/symbolstyle-color/symbolshadowstyle-no/gradient-no/bridge_old.png"
   
   $scope.$watch 'local.end', ->
    if $scope.local.end is -1
      return
    console.log "End changed"
    markers = sharedProperties.Properties().markers
    for marker in markers
      if marker.status == "end"
        marker.icon = "http://mapicons.nicolasmollet.com/wp-content/uploads/mapicons/shape-default/color-66c547/shapecolor-light/shadow-1/border-white/symbolstyle-dark/symbolshadowstyle-no/gradient-no/bridge_old.png"
        marker.status = "inactive"
    sharedProperties.setMarkers = markers
    $scope.local.markers[$scope.local.end].status = "end"
    $scope.prevIcon = $scope.local.markers[$scope.local.end].icon = "http://mapicons.nicolasmollet.com/wp-content/uploads/mapicons/shape-default/color-262626/shapecolor-color/shadow-1/border-dark/symbolstyle-white/symbolshadowstyle-dark/gradient-no/bridge_old.png"
]
