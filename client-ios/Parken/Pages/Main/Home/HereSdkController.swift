import heresdk
import UIKit

class HereSdkController: TapDelegate, LongPressDelegate {
    
    private var mapView: MapViewLite
    private var searchEngine: SearchEngine
    
    init(mapView: MapViewLite) {
        self.mapView = mapView
        
        do {
            try searchEngine = SearchEngine()
        } catch let engineInstantiationError {
            fatalError("Failed to initialize SearchEngine. Cause: \(engineInstantiationError)")
        }
        
        mapView.gestures.tapDelegate = self
        mapView.gestures.longPressDelegate = self
    }
    
    func getAutoSuggest(textQuery: String, action: @escaping (SearchError?, [Suggestion]?)-> ()) {
        let centerGeoCoordinates = getViewCenter()
        let autoSuggestOptions = SearchOptions(languageCode: LanguageCode.ptBr,
                                               maxItems: 5)
        
        _ = searchEngine.suggest(textQuery: TextQuery(textQuery, near: centerGeoCoordinates),
                                 options: autoSuggestOptions,
                                 completion: action)
    }
    
    func getAddressByCoordinates(geoCoordinates: GeoCoordinates, action: @escaping (SearchError?, [Place]?)-> ()) {
        let reverseGeocodingOptions = SearchOptions(languageCode: LanguageCode.ptBr,
                                                    maxItems: 1)
        
        _ = searchEngine.search(coordinates: geoCoordinates,
                                options: reverseGeocodingOptions,
                                completion: action)
    }
    
    // Conforming to TapDelegate protocol.
    func onTap(origin: Point2D) {
        // TODO: go to step = 3
        mapView.pickMapItems(at: origin, radius: 2, completion: { (pickedMapItems: PickMapItemsResultLite?) -> () in
            guard let topmostMapMarker = pickedMapItems?.topmostMarker else {
                return
            }
            
            if let searchResultMetadata =
                topmostMapMarker.metadata?.getCustomValue(key: "key_search_result") as? SearchResultMetadata {
                
                let title = searchResultMetadata.searchResult.title
                let vicinity = searchResultMetadata.searchResult.address.addressText
                
                print("Picked Search Result Title: \(title), Vicinity: \(vicinity)")
                return
            }
            
            print("Map Marker picked at: \(topmostMapMarker.coordinates.latitude), \(topmostMapMarker.coordinates.longitude)")
        })
    }
    
    // Conforming to LongPressDelegate protocol.
    func onLongPress(state: GestureState, origin: Point2D) {
        if (state == .begin) {
            let geoCoordinates = mapView.camera.viewToGeoCoordinates(viewCoordinates: origin)
            //TODO: call setDestineLocateMarker and set step = 2
        }
    }
    
    func createPointMarker(geoCoordinates: GeoCoordinates) -> MapMarkerLite {
        let mapMarker = MapMarkerLite(at: geoCoordinates)
        
        let image = UIImage(named: "poi")
        
        let mapImage = MapImageLite(image!)
        let mapMarkerImageStyle = MapMarkerImageStyleLite()
        mapMarkerImageStyle.setAnchorPoint(Anchor2D(horizontal: 0.5, vertical: 1))
        
        mapMarker.addImage(mapImage!, style: mapMarkerImageStyle)
        
        return mapMarker
    }
    
    private func createCircleMarker(geoCoordinates: GeoCoordinates, imageName: String) -> MapMarkerLite {
        let mapMarker = MapMarkerLite(at: geoCoordinates)
        
        let image = UIImage(named: imageName)
        let mapImage = MapImageLite(image!)
        
        mapMarker.addImage(mapImage!, style: MapMarkerImageStyleLite())
        
        return mapMarker
    }
    
    func addCircleMarker(imageName: String, geoCoordinates: GeoCoordinates, lastMarker: MapMarkerLite?) -> MapMarkerLite {
        let mapMarker = createCircleMarker(geoCoordinates: geoCoordinates, imageName: imageName)
        
        if let lastMarker = lastMarker {
            mapView.mapScene.removeMapMarker(lastMarker)
        }
        
        mapView.mapScene.addMapMarker(mapMarker)
        
        return mapMarker
    }
    
    func addMarkerList(markerList: [MapMarkerLite]) {
        for mapMarker in markerList {
            mapView.mapScene.addMapMarker(mapMarker)
        }
    }
    
    
    func cleanMarker(mapMarker: MapMarkerLite) {
        mapView.mapScene.removeMapMarker(mapMarker)
    }
    
    func clearMarkerList(markerList: [MapMarkerLite]) {
        for mapMarker in markerList {
            mapView.mapScene.removeMapMarker(mapMarker)
        }
    }
    
    
    func getViewCenter() -> GeoCoordinates {
        return mapView.camera.getTarget()
    }
    
    func getViewGeoBox() -> GeoBox {
        return mapView.camera.boundingBox
    }
    
    func centralize(geoCoordinates: GeoCoordinates) {
        let camera = mapView.camera
        
        camera.setTarget(geoCoordinates)
        camera.setZoomLevel(13)
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
