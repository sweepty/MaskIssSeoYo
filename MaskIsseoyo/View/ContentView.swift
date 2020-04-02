//
//  ContentView.swift
//  MaskIsseoyo
//
//  Created by Seungyeon Lee on 2020/03/12.
//  Copyright © 2020 Seungyeon Lee. All rights reserved.
//

import SwiftUI
import CoreLocation
import MapKit

struct ContentView: View {
    @State private var locationManager = CLLocationManager()
    @State private var mapView = MKMapView(frame: .zero)
    
    @State private var nearByStores: [Store]?
    @State private var myLocation: CLLocationCoordinate2D?
    @State private var selectedStore: Store?
    @State private var showNoDataAlert: Bool = false
    @State private var showNetworkAlert: Bool = false
    @State private var showLocationPermissionAlert: Bool = false
    
    let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                Button(action: {
                    // 현재 지도 위치에서 재검색
                    let userLocation = self.mapView.centerCoordinate
                    API.storesByGeo(coordinate: userLocation) { (result) in
                        
                        switch result {
                        case .success(let storeList):
                            self.nearByStores = storeList
                        case .failure(let error):
                            switch error {
                            case .server:
                                self.showNetworkAlert = true
                            default:
                                self.showNoDataAlert = true
                            }
                            
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("이 지역 재검색하기")
                    }
                    .padding(10)
                    .foregroundColor(.blue)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                }.zIndex(1)
                .position(x: geometry.size.width/2, y: 70)
                
                // 현재 내 위치로 이동
                Button(action: {
                    #if DEBUG
                    let centerDev = CLLocationCoordinate2D(latitude: 37.567480, longitude: 126.988257)
                    let regionDev = MKCoordinateRegion(center: centerDev, span: self.coordinateSpan)
                    self.mapView.setRegion(regionDev, animated: true)
                    #endif
                    guard let center = self.locationManager.location?.coordinate else { return }
                    let region = MKCoordinateRegion(center: center, span: self.coordinateSpan)
                    self.mapView.setRegion(region, animated: true)
                    
                    
                }) {
                    HStack {
                        Image(systemName: "location.fill")
                    }
                    .padding()
                    .foregroundColor(.blue)
                    .background(Color.white)
                    .clipShape(Circle())
                }
                .zIndex(1)
                .position(x: geometry.size.width - 40, y: 100)
                
                
                if self.selectedStore != nil {
                    VStack(alignment: .leading) {
                        Text(self.selectedStore?.name ?? "")
                            .font(.largeTitle)
                            .padding(.top, 8)
                        
                        // 판매처 주소
                        Text("\(self.selectedStore?.addr ?? "")")
                            .font(.footnote)
                            .padding(.bottom)
                        
                        // 마스크 수량
                        HStack {
                            Text("\(self.selectedStore?.maskRemainLevel.rawValue ?? "")")
                                .fontWeight(.semibold)
                                .font(.headline)
                        }
                        .padding(15)
                        .frame(width: geometry.size.width - 40)
                        .foregroundColor(.white) .background(Color.init(self.selectedStore?.maskRemainLevel.color ?? UIColor.white))
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        
                        HStack {
                            Text("입고 시간")
                                .fontWeight(.semibold)
                            Text("\(self.selectedStore?.stockAt?.toDate()?.convertAgo() ?? "-" )")
                        }.padding(.top)
                        
                        HStack {
                            Image(systemName: "info.circle")
                            Text("입고 시간과 실제 판매 개시 시간은 다를 수 있습니다.")
                                .font(.footnote)
                        }
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 8.0)
                        
                    }
                    .padding()
                    .background(Color.init(UIColor.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                    .zIndex(1)
                    .position(x: geometry.size.width / 2, y: geometry.size.height - geometry.safeAreaInsets.bottom)
                }
                
                MapView(
                    locationManager: self.$locationManager,
                    mapView: self.$mapView,
                    storeList: self.$nearByStores,
                    selectedStore: self.$selectedStore
                )
                .alert(isPresented: self.$showLocationPermissionAlert) {
                    Alert(
                        title: Text("사용자의 현재 위치에 접근할 수 없습니다."),
                        message: Text("위치 정보 사용 설정을 허용으로 바꿔주세요."),
                        dismissButton: .default(Text("확인"), action: { self.goToDeviceSettings() })
                    )
                }
                .alert(isPresented: self.$showNoDataAlert) {
                    Alert(
                        title: Text("주변에 마스크 판매점이 없어요"),
                        message: Text("반경 \(String(Constants.meter))m 이내에 공적마스크 판매점이 없습니다.😢"),
                        dismissButton: .default(Text("확인"))
                    )
                }
                .alert(isPresented: self.$showNetworkAlert) {
                    Alert(
                        title: Text("네트워크 오류"),
                        message: Text("네트워크 연결이 필요합니다."),
                        dismissButton: .default(Text("확인"))
                    )
                }
                .edgesIgnoringSafeArea(.vertical)
                .onAppear {
                    self.locationManager.requestWhenInUseAuthorization()
                    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    
                    #if DEBUG
                    // 37.567480, 126.988257
                    self.myLocation = CLLocationCoordinate2D(latitude: 37.567480, longitude: 126.988257)
                    #endif
                    
                    self.myLocation = self.locationManager.location?.coordinate
                    
                    /// Call API
                    guard let userLocation = self.myLocation else {
                        /// Permission Handling
                        self.showLocationPermissionAlert = true
                        return
                    }
                    
                    API.storesByGeo(coordinate: userLocation) { (result) in
                        switch result {
                        case .success(let storeList):
                            self.nearByStores = storeList
                        case .failure(let error):
                            self.showNoDataAlert = true
                        }
                    }
                }
            }.edgesIgnoringSafeArea(.all)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MapView: UIViewRepresentable {
    @Binding var locationManager: CLLocationManager
    @Binding var mapView: MKMapView
    @Binding var storeList: [Store]?
    @Binding var selectedStore: Store?
    var insideSelected: Store?
    
    let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    
    func makeUIView(context: Context) -> MKMapView {
        let map = self.mapView
        map.showsUserLocation = true
        map.userTrackingMode = .follow
        map.showsCompass = false
        map.delegate = context.coordinator
        
        let dismissDetailTapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(MapViewCoordinator.tapped))
        
        map.addGestureRecognizer(dismissDetailTapGesture)
        map.register(MaskMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        
        // get user Location
        guard let currentLocation = self.locationManager.location?.coordinate else { return map }
        let region = MKCoordinateRegion(center: currentLocation, span: self.coordinateSpan)
        map.setRegion(region, animated: true)
        
        return map
        
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        MapViewCoordinator(self)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        /// TODO: Prevent annotation update in map if user tapped pins
        updateAnnotations(from: uiView)
    }
    
    private func updateAnnotations(from mapView: MKMapView) {
        if let stores = storeList {
            DispatchQueue.main.async {
                mapView.removeAnnotations(mapView.annotations)
                let newAnnotations = stores.map { StoreAnnotation(store: $0) }
                mapView.addAnnotations(newAnnotations)
            }
        }
    }
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        var mapViewController: MapView
        
        init(_ control: MapView) {
            self.mapViewController = control
        }
        
        /// Set selected store to nil value
        @objc func tapped(gesture: UITapGestureRecognizer) {
            let tapLocation = gesture.location(in: self.mapViewController.mapView)
            
            if let subview = self.mapViewController.mapView.hitTest(tapLocation, with: nil) {
                if subview.isKind(of: NSClassFromString("MKAnnotationContainerView")!) {
                    self.mapViewController.selectedStore = nil
                }
            }
        }
        
        /// 위치 권한 설정 변경되었을 때
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            #if DEBUG
            print("\(type(of: self)).\(#function): status=", terminator: "")
            switch status {
            case .notDetermined:       print(".notDetermined")
            case .restricted:          print(".restricted")
            case .denied:              print(".denied")
            case .authorizedAlways:    print(".authorizedAlways")
            case .authorizedWhenInUse: print(".authorizedWhenInUse")
            @unknown default:          print("@unknown")
            }
            #endif

            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                self.mapViewController.locationManager.startUpdatingLocation()
            default:
                self.mapViewController.mapView.setUserTrackingMode(.none, animated: true)
            }
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let myAnnotation = view.annotation as? StoreAnnotation else { return }
            // Add selectedStore
            let selectedStore = mapViewController.storeList?.compactMap({ (value) -> Store? in
                return value.code == myAnnotation.id ? value : nil
            })
            guard let firstFind = selectedStore?.first else { return }
            
            self.mapViewController.selectedStore = firstFind
        }
    }
}

extension ContentView {
  ///Path to device settings if location is disabled
  func goToDeviceSettings() {
    guard let url = URL.init(string: UIApplication.openSettingsURLString) else { return }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
}
