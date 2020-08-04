import heresdk
import UIKit

class HereSdkController: TapDelegate, LongPressDelegate {
    
    private var viewController: HomeViewController//UIViewController
    private var mapView: MapViewLite
    private var searchEngine: SearchEngine
    private var mapMarkers = [MapMarkerLite]()
    
    var userLocateMapMarker: MapMarkerLite?
    var destineLocateMapMarker: MapMarkerLite?
    
    init(viewController: HomeViewController, mapView: MapViewLite) {
        self.viewController = viewController
        self.mapView = mapView
        
        do {
            try searchEngine = SearchEngine()
        } catch let engineInstantiationError {
            fatalError("Failed to initialize SearchEngine. Cause: \(engineInstantiationError)")
        }
        
        mapView.gestures.tapDelegate = self
        mapView.gestures.longPressDelegate = self
    }
    
    func getAddressForCoordinates(geoCoordinates: GeoCoordinates) {
        let reverseGeocodingOptions = SearchOptions(languageCode: LanguageCode.ptBr,
                                                    maxItems: 1)
        _ = searchEngine.search(coordinates: geoCoordinates,
                                options: reverseGeocodingOptions,
                                completion: onReverseGeocodingCompleted)
    }
    
    func onReverseGeocodingCompleted(error: SearchError?, items: [Place]?) {
        if let searchError = error {
            showDialog(title: "ReverseGeocodingError", message: "Error: \(searchError)")
            return
        }
        
        // If error is nil, it is guaranteed that the place list will not be empty.
        let addressText = items!.first!.address.addressText
        showDialog(title: "Reverse geocoded address:", message: addressText)
    }
    
    func getSuggest(textQuery: String) {
        clearMapMarkers()
        cleanDestineLocateMarker()
        
        let centerGeoCoordinates = getMapViewCenter()
        let autosuggestOptions = SearchOptions(languageCode: LanguageCode.ptBr,
                                               maxItems: 5)
        
        _ = searchEngine.suggest(textQuery: TextQuery(textQuery, near: centerGeoCoordinates),
                                 options: autosuggestOptions,
                                 completion: onSearchCompleted)
    }
    
    func onSearchCompleted(error: SearchError?, items: [Suggestion]?) {
        if let searchError = error {
            print("Autosuggest Error: \(searchError)")
            return
        }
        
        // If error is nil, it is guaranteed that the items will not be nil.
        print("Autosuggest: Found \(items!.count) result(s).")
        
        viewController.suggestAddressList = items!
    }
    

    // Conforming to TapDelegate protocol.
    func onTap(origin: Point2D) {
        mapView.pickMapItems(at: origin, radius: 2, completion: onMapItemsPicked)
    }
    
    func onMapItemsPicked(pickedMapItems: PickMapItemsResultLite?) {
        guard let topmostMapMarker = pickedMapItems?.topmostMarker else {
            return
        }
        
        if let searchResultMetadata =
            topmostMapMarker.metadata?.getCustomValue(key: "key_search_result") as? SearchResultMetadata {
            
            let title = searchResultMetadata.searchResult.title
            let vicinity = searchResultMetadata.searchResult.address.addressText
            showDialog(title: "Picked Search Result",
                       message: "Title: \(title), Vicinity: \(vicinity)")
            return
        }
        
        showDialog(title: "Map Marker picked at: ",
                   message: "\(topmostMapMarker.coordinates.latitude), \(topmostMapMarker.coordinates.longitude)")
    }
    
    // Conforming to LongPressDelegate protocol.
    func onLongPress(state: GestureState, origin: Point2D) {
        
        if (state == .begin) {
            let geoCoordinates = mapView.camera.viewToGeoCoordinates(viewCoordinates: origin)
            setDestineLocateMarker(geoCoordinates: geoCoordinates)
        }
    }
    
    func addPoiMapMarker(geoCoordinates: GeoCoordinates) {
        let mapMarker = createPoiMapMarker(geoCoordinates: geoCoordinates)
        
        mapView.mapScene.addMapMarker(mapMarker)
        mapMarkers.append(mapMarker)
    }
    
    private func addPoiMapMarker(geoCoordinates: GeoCoordinates, metadata: Metadata) {
        let mapMarker = createPoiMapMarker(geoCoordinates: geoCoordinates)
        mapMarker.metadata = metadata
        
        mapView.mapScene.addMapMarker(mapMarker)
        mapMarkers.append(mapMarker)
    }
    
    private func createPoiMapMarker(geoCoordinates: GeoCoordinates) -> MapMarkerLite {
        let mapMarker = MapMarkerLite(at: geoCoordinates)
        
        let image = UIImage(named: "poi")
        
        let mapImage = MapImageLite(image!)
        
        let mapMarkerImageStyle = MapMarkerImageStyleLite()
        mapMarkerImageStyle.setAnchorPoint(Anchor2D(horizontal: 0.5, vertical: 1))
        mapMarker.addImage(mapImage!, style: mapMarkerImageStyle)
        
        return mapMarker
    }
    
    func setUserLocateMarker(geoCoordinates: GeoCoordinates) {
        let mapMarker = createCircleMapMarker(geoCoordinates: geoCoordinates, imageName: "green_dot")
        
        if let userLocateMapMarker = userLocateMapMarker {
            mapView.mapScene.removeMapMarker(userLocateMapMarker)
        }
        
        userLocateMapMarker = mapMarker
        mapView.mapScene.addMapMarker(mapMarker)
    }
    
    func setDestineLocateMarker(geoCoordinates: GeoCoordinates) {
        let mapMarker = createCircleMapMarker(geoCoordinates: geoCoordinates, imageName: "red_dot")
        
        if let destineLocateMapMarker = destineLocateMapMarker {
            mapView.mapScene.removeMapMarker(destineLocateMapMarker)
        }
        
        destineLocateMapMarker = mapMarker
        mapView.mapScene.addMapMarker(mapMarker)
    }
    
    func cleanDestineLocateMarker() {
        if let mapMarker = destineLocateMapMarker {
            destineLocateMapMarker = nil
            mapView.mapScene.removeMapMarker(mapMarker)
        }
    }
    
    private func createCircleMapMarker(geoCoordinates: GeoCoordinates, imageName: String) -> MapMarkerLite {
        let mapMarker = MapMarkerLite(at: geoCoordinates)
        
        let image = UIImage(named: imageName)
        
        let mapImage = MapImageLite(image!)
        mapMarker.addImage(mapImage!, style: MapMarkerImageStyleLite())
        
        return mapMarker
    }
    
    private func clearMapMarkers() {
        for mapMarker in mapMarkers {
            mapView.mapScene.removeMapMarker(mapMarker)
        }
        
        mapMarkers.removeAll()
    }
    
    func generateRandomMapMarkers(quantity: Int) {
        for _ in 1...quantity {
            addPoiMapMarker(geoCoordinates: getRandomGeoCoordinatesInViewport())
        }
    }
    
    private func getRandomGeoCoordinatesInViewport() -> GeoCoordinates {
        let geoBox = getMapViewGeoBox()
        let northEast = geoBox.northEastCorner
        let southWest = geoBox.southWestCorner
        
        let minLat = southWest.latitude
        let maxLat = northEast.latitude
        let lat = getRandom(min: minLat, max: maxLat)
        
        let minLon = southWest.longitude
        let maxLon = northEast.longitude
        let lon = getRandom(min: minLon, max: maxLon)
        
        return GeoCoordinates(latitude: lat, longitude: lon)
    }
    
    private func getRandom(min: Double, max: Double) -> Double {
        return Double.random(in: min ... max)
    }
    
    private func getMapViewCenter() -> GeoCoordinates {
        return mapView.camera.getTarget()
    }
    
    private func getMapViewGeoBox() -> GeoBox {
        return mapView.camera.boundingBox
    }
    
    private func showDialog(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    private class SearchResultMetadata : CustomMetadataValue {
        var searchResult: Place
        
        init(_ searchResult: Place) {
            self.searchResult = searchResult
        }
        
        func getTag() -> String {
            return "SearchResult Metadata"
        }
    }
}
