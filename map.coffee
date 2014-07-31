app = angular.module 'mapApp', ['google-maps', 'services']

app.controller 'infoController', ['$scope', 'sharedProperties', ($scope, sharedProperties) ->
  $scope.onStartClick = () ->
    sharedProperties.setStart($scope.model.id)
    
  $scope.onEndClick = () ->
    sharedProperties.setEnd($scope.model.id)

  $scope.onStreetViewClick = ->
    currentId = $scope.model.id
    properties = sharedProperties.Properties()
    map = properties.panorama
    gMap = map.getGMap()
    panorama = gMap.getStreetView()
    lat = properties.markers[currentId].latitude 
    lng = properties.markers[currentId].longitude
    panorama.setPosition new google.maps.LatLng lat, lng
    panorama.setVisible true
    sharedProperties.setPanorama map
]

app.controller 'mapController', ['$scope', 'sharedProperties',($scope, sharedProperties) ->
  $scope.markers = []
  
  $scope.map = {
    'center': {'latitude': 33.884388, 'longitude': -117.641235},
    'zoom': 12,
  }

  $scope.streetView = {}
  
  $scope.local = sharedProperties.Properties()

  $scope.showTraffic = false

  $scope.toggleTrafficLayer =  ->
    $scope.showTraffic = !$scope.showTraffic

  setMarkerToStart = (marker) ->
    if not marker? 
      return
    marker.status = "start"
    marker.icon = "/states/startpoint.png"
    marker.prevIcon = "/states/startpoint.png"
  
  setMarkerToInactive = (marker) ->
    if not marker? 
      return
    marker.status = "inactive"
    marker.icon = "/states/inactive.png"
    marker.prevIcon = "/states/inactive.png"

  setMarkerToEnd = (marker) ->
    if not marker? 
      return
    marker.status = "end"
    marker.icon = "/states/endpoint.png"
    marker.prevIcon = "/states/endpoint.png"
	
  latlngs = []

  latlngs.push {'latitude': 33.843801, 'longitude': -117.717234}
  latlngs.push {'latitude': 33.826690, 'longitude': -117.716419}
  latlngs.push {'latitude': 33.820415, 'longitude': -117.716977}
  
  latlngs.forEach (element, index) ->
    marker = new Marker index, element.latitude, element.longitude 
	
    marker.close = -> 
      @model.icon = marker.prevIcon
      @model.showWindow = false
      $scope.$apply()
	  
    marker.onClick = ->
      @model.status = "focused"
      sharedProperties.setPanorama $scope.streetView
      $scope.local.markers.forEach (element) -> 
        element.showWindow = false
        element.icon = element.prevIcon
      @model.icon = "/states/focused.png"
      @model.showWindow = true
      $scope.id = @model.id
      $scope.$apply()
	  
    $scope.local.markers.push marker
  
  $scope.$watchCollection 'local.route', (newValues, oldValues, scope) ->
    if not newValues? 
      return
    startId = newValues.start
    endId = newValues.end
    if (startId is -1) and (endId is -1) or (startId is endId)
      return
    markers = sharedProperties.Properties().markers
    markers.forEach (marker) ->
      setMarkerToInactive(marker) if marker.status is "start" or marker.status is "end"
    sharedProperties.setMarkers markers
    setMarkerToStart markers[startId]
    setMarkerToEnd markers[endId]    
]
