import heresdk
import UIKit

class HereSdkController: TapDelegate, LongPressDelegate {
    
    private var viewController: HomeViewController
    private var mapView: MapViewLite
    private var searchEngine: SearchEngine
    
    var userLocateMapMarker: MapMarkerLite?
    
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
        viewController.suggestAddressTable.reloadData()
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
    
    func createPoiMapMarker(geoCoordinates: GeoCoordinates) -> MapMarkerLite {
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
        
        if let destineLocateMapMarker = viewController.destineLocateMapMarker {
            mapView.mapScene.removeMapMarker(destineLocateMapMarker)
        }
        
        viewController.destineLocateMapMarker = mapMarker
        mapView.mapScene.addMapMarker(mapMarker)
    }
    
    func cleanDestineLocateMarker() {
        if let mapMarker = viewController.destineLocateMapMarker {
            viewController.destineLocateMapMarker = nil
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
    
    func drawMapMarkers(markerList: [MapMarkerLite]) {
        for mapMarker in markerList {
            mapView.mapScene.addMapMarker(mapMarker)
        }
    }
    
    func clearMapMarkers() {
        for mapMarker in viewController.parkingLocateList {
            mapView.mapScene.removeMapMarker(mapMarker.Localization)
        }
        
        viewController.parkingLocateList.removeAll()
    }
    
    func getMapViewCenter() -> GeoCoordinates {
        return mapView.camera.getTarget()
    }
    
    func getMapViewGeoBox() -> GeoBox {
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
