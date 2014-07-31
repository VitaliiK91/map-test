app = angular.module 'mapApp', ['google-maps', 'services']

# InfoWindow controller
app.controller 'infoController', ['$scope', 'sharedProperties', ($scope, sharedProperties) ->
  
  $scope.onStartClick = () -> sharedProperties.setStart($scope.model.id) 
  $scope.onEndClick = () -> sharedProperties.setEnd($scope.model.id)

  $scope.onStreetViewClick = ->
    properties = sharedProperties.Properties()
    currentMarker = properties.markers[$scope.model.id]
    streetMap = properties.panorama
    streetMap.setPosition currentMarker.glatlng  #glatlng contains google latlng literal
    streetMap.setVisible true
]

# Map Controller

app.controller 'mapController', ['$scope', 'sharedProperties', 'markerService', 
 ($scope, sharedProperties, markerService) ->
  
  $scope.markers = []
  
  $scope.map = {
    'center': {'latitude': 33.884388, 'longitude': -117.641235},
    'zoom': 12,
    'streetView': {},
    'local': sharedProperties.Properties(),
    'showTraffic': false,
    'toggleTrafficLayer': -> $scope.map.showTraffic = !$scope.map.showTraffic
  }
    
  latlngs = []

  latlngs.push {'latitude': 33.843801, 'longitude': -117.717234}
  latlngs.push {'latitude': 33.826690, 'longitude': -117.716419}
  latlngs.push {'latitude': 33.820415, 'longitude': -117.716977}
  
  # Creating the markers
  latlngs.forEach (element, index) ->
    marker = new Marker index, element
    marker.close = ->
      markerService.setMarkerDefault @model
      $scope.$apply()
	  
    marker.onClick = ->
      # Saving the streetview map
      sharedProperties.setPanorama $scope.map.streetView
      # Set all markers to their default just in case one that was focused wasn't closed
      $scope.map.local.markers.forEach (element) -> markerService.setMarkerDefault element
      markerService.setMarkerStatus @model, "focused"
      $scope.id = @model.id
      $scope.$apply()
	  
    $scope.map.local.markers.push marker
  
  $scope.$watchCollection 'map.local.route', (newValues, oldValues, scope) ->
    startId = newValues.start
    endId = newValues.end
    # Check is needed just in case the current start is trying to be overwritten by end
    if (startId is -1) and (endId is -1) or (startId is endId)
      return
    markers = sharedProperties.Properties().markers
    # Set other markers that were previously start or end to inactive
    markers.forEach (marker) ->
      if marker.status is "start" or marker.status is "end"
        markerService.setMarkerStatus marker, "inactive" 
    
    sharedProperties.setMarkers markers
    markerService.setMarkerStatus markers[startId], 'start'; markerService.setMarkerStatus markers[endId], 'end'
]
