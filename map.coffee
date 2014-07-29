app = angular.module 'mapApp', ['google-maps']

app.controller 'infoController', ['$scope', ($scope) ->
  $scope.init = (id) ->
    $scope.id = $scope.$parent.id
    console.log $scope.$parent.id

  $scope.onStartClick = () ->
    console.log "Start at " + $scope.model.id
    $scope.local.start = $scope.model.id
    $scope.model.icon = "http://mapicons.nicolasmollet.com/wp-content/uploads/mapicons/shape-default/color-262626/shapecolor-white/shadow-1/border-color/symbolstyle-color/symbolshadowstyle-no/gradient-no/bridge_old.png"
  $scope.onEndClick = () ->
    console.log "Ends at " + $scope.model.id
    console.log $scope.map
    $scope.$parent.local.end = $scope.model.id
    console.log $scope
    $scope.model.icon = "http://mapicons.nicolasmollet.com/wp-content/uploads/mapicons/shape-default/color-262626/shapecolor-color/shadow-1/border-dark/symbolstyle-white/symbolshadowstyle-dark/gradient-no/bridge_old.png"
]

app.controller 'mapController', ['$scope', ($scope) ->
  $scope.markers = []
  $scope.map = {
    'center': {'latitude': 33.884388, 'longitude': -117.641235},
    'zoom': 12 
  }
  $scope.local = {}
  $scope.local.start = 0
  $scope.local.end = 0

  latlngs = []

  latlngs.push {'latitude': 33.884780, 'longitude': -117.639754}
  latlngs.push {'latitude': 33.884388, 'longitude': -117.641235}
  latlngs.push {'latitude': 33.883924, 'longitude': -117.643724}

  for latlng, i in latlngs
    marker = {}
    marker.start = 0
    marker.end = 0
    marker.latitude = latlng.latitude
    marker.longitude = latlng.longitude
    marker.id = i
    marker.icon = "http://mapicons.nicolasmollet.com/wp-content/uploads/mapicons/shape-default/color-66c547/shapecolor-light/shadow-1/border-white/symbolstyle-dark/symbolshadowstyle-no/gradient-no/bridge_old.png"
    marker.showWindow = false
    marker.close = ->
      @model.showWindow = false
      $scope.$apply()
    marker.onClick = ->
      for markerr in $scope.markers
        markerr.showWindow = false
      @model.showWindow = true
      $scope.id = @model.id
      $scope.$apply()
    $scope.markers.push marker

]
