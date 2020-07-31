import heresdk
import UIKit

class HereSdkController: TapDelegate, LongPressDelegate {

    private var viewController: HomeViewController//UIViewController
    private var mapView: MapViewLite
    private var mapMarkers = [MapMarkerLite]()
    private var searchEngine: SearchEngine
    
    init(viewController: HomeViewController/*UIViewController*/, mapView: MapViewLite) {
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
    
    func getSuggest(textQuery: String) {
        clearMap()
        
        let centerGeoCoordinates = getMapViewCenter()
        let autosuggestOptions = SearchOptions(languageCode: LanguageCode.ptBr,
                                               maxItems: 5)

        _ = searchEngine.suggest(textQuery: TextQuery(textQuery, near: centerGeoCoordinates),
                                 options: autosuggestOptions,
                                 completion: onSearchCompleted)
    }
    
    // Completion handler to receive auto suggestion results.
    func onSearchCompleted(error: SearchError?, items: [Suggestion]?) {
        if let searchError = error {
            print("Autosuggest Error: \(searchError)")
            return
        }

        // If error is nil, it is guaranteed that the items will not be nil.
        print("Autosuggest: Found \(items!.count) result(s).")

        var results: [String] = []
        for autosuggestResult in items! {
            results.append(autosuggestResult.title)
        }
        
        viewController.addressList = results
    }

    // Conforming to TapDelegate protocol.
    func onTap(origin: Point2D) {
        // TODO: ???
        mapView.pickMapItems(at: origin, radius: 2, completion: onMapItemsPicked)
    }

    // Completion handler to pick itmes from map.
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
        // TODO: Pegar endereco e definir no label de busca
        
        if (state == .begin) {
            let geoCoordinates = mapView.camera.viewToGeoCoordinates(viewCoordinates: origin)
            addPoiMapMarker(geoCoordinates: geoCoordinates)
            getAddressForCoordinates(geoCoordinates: geoCoordinates)
        }
    }

    // Completion handler to receive reverse geocoding results.
    func onReverseGeocodingCompleted(error: SearchError?, items: [Place]?) {
        if let searchError = error {
            showDialog(title: "ReverseGeocodingError", message: "Error: \(searchError)")
            return
        }

        // If error is nil, it is guaranteed that the place list will not be empty.
        let addressText = items!.first!.address.addressText
        showDialog(title: "Reverse geocoded address:", message: addressText)
    }

    private func addPoiMapMarker(geoCoordinates: GeoCoordinates) {
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

    private func clearMap() {
        for mapMarker in mapMarkers {
            mapView.mapScene.removeMapMarker(mapMarker)
        }

        mapMarkers.removeAll()
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
