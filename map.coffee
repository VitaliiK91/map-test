app = angular.module 'mapApp', ['google-maps']

app.controller 'mapController', ['$scope', ($scope) ->
  $scope.markers = []
  $scope.map = {
    'center': {'latitude': 33.884388, 'longitude': -117.641235},
    'zoom': 12 
  }
  latlngs = []

  latlngs.push {'latitude': 33.884780, 'longitude': -117.639754}
  latlngs.push {'latitude': 33.884388, 'longitude': -117.641235}
  latlngs.push {'latitude': 33.883924, 'longitude': -117.643724}

  for latlng, i in latlngs
    marker = {}
    marker.latitude = latlng.latitude
    marker.longitude = latlng.longitude
    marker.id = i
    marker.showWindow = false
    marker.close = ->
      @model.showWindow = false
    marker.onClick = ->
      @model.showWindow = true
      $scope.id = @model.id
      $scope.$apply()
    $scope.markers.push marker
]
