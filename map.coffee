app = angular.module 'mapApp', ['google-maps', 'services']

app.controller 'infoController', ['$scope', 'sharedProperties', ($scope, sharedProperties) ->
  
  $scope.onStartClick = () -> sharedProperties.setStart($scope.model.id) 
  $scope.onEndClick = () -> sharedProperties.setEnd($scope.model.id)

  $scope.onStreetViewClick = ->
    properties = sharedProperties.Properties()
    currentMarker = properties.markers[$scope.model.id]
    streetMap = properties.panorama
    streetMap.setPosition new google.maps.LatLng currentMarker.latitude, currentMarker.longitude
    streetMap.setVisible true
]

app.controller 'mapController', ['$scope', 'sharedProperties', 'markerService', 
 ($scope, sharedProperties, markerService) ->
  
  $scope.markers = []
  
  $scope.map = {
    'center': {'latitude': 33.884388, 'longitude': -117.641235},
    'zoom': 12,
  }

  $scope.streetView = {}
  
  $scope.local = sharedProperties.Properties()

  $scope.showTraffic = false

  $scope.toggleTrafficLayer =  -> $scope.showTraffic = !$scope.showTraffic	
    
  latlngs = []

  latlngs.push {'latitude': 33.843801, 'longitude': -117.717234}
  latlngs.push {'latitude': 33.826690, 'longitude': -117.716419}
  latlngs.push {'latitude': 33.820415, 'longitude': -117.716977}
  
  latlngs.forEach (element, index) ->
    marker = new Marker index, element.latitude, element.longitude 
	
    marker.close = ->
      markerService.setMarkerDefault @model
      $scope.$apply()
	  
    marker.onClick = ->
      sharedProperties.setPanorama $scope.streetView
      $scope.local.markers.forEach (element) -> markerService.setMarkerDefault element
      markerService.setMarkerStatus @model, "focused"
      $scope.id = @model.id
      $scope.$apply()
	  
    $scope.local.markers.push marker
  
  $scope.$watchCollection 'local.route', (newValues, oldValues, scope) ->
    startId = newValues.start
    endId = newValues.end
    # Check is needed just in case the current start is trying to be overwritten by end
    if (startId is -1) and (endId is -1) or (startId is endId)
      return
    markers = sharedProperties.Properties().markers
    
    markers.forEach (marker) ->
      if marker.status is "start" or marker.status is "end"
        markerService.setMarkerStatus marker, "inactive" 
    
    sharedProperties.setMarkers markers
    markerService.setMarkerStatus markers[startId], 'start'; markerService.setMarkerStatus markers[endId], 'end'
]
