app = angular.module 'mapApp', ['google-maps']

app.service 'sharedProperties', ->
  props = {
    start: 0,
    end: 0
  }
  return {
    Properties: -> return props,
    setStart: (val) -> props.start = val,
    setEnd: (val) -> props.end = val
  }

app.controller 'infoController', ['$scope', 'sharedProperties', ($scope, sharedProperties) ->
  $scope.onStartClick = () ->
    sharedProperties.setStart($scope.model.id)
    $scope.model.icon = "http://mapicons.nicolasmollet.com/wp-content/uploads/mapicons/shape-default/color-262626/shapecolor-white/shadow-1/border-color/symbolstyle-color/symbolshadowstyle-no/gradient-no/bridge_old.png"
  $scope.onEndClick = () ->
    sharedProperties.setEnd($scope.model.id)
    $scope.model.icon = "http://mapicons.nicolasmollet.com/wp-content/uploads/mapicons/shape-default/color-262626/shapecolor-color/shadow-1/border-dark/symbolstyle-white/symbolshadowstyle-dark/gradient-no/bridge_old.png"
]

app.controller 'mapController', ['$scope', 'sharedProperties',($scope, sharedProperties) ->
  $scope.markers = []
  $scope.map = {
    'center': {'latitude': 33.884388, 'longitude': -117.641235},
    'zoom': 12 
  }

  $scope.local = sharedProperties.Properties()

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
