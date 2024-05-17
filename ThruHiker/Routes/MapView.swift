//
//  MapView.swift
//  ThruHiker
//
//  Created by Kai Linsley on 5/8/24.
//

import SwiftUI
@_spi(Experimental) import MapboxMaps

struct MapView: View {
    
    @EnvironmentObject var healthKitManager: HealthKitManager
    
    //@Binding var sharedState: SharedState
    @Binding var route: Route
    @State private var showSheet = false
    
    @StateObject var viewModel = WeatherViewModel()
    
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    @State private var Mile: Double = 0.0
    @State var startDate: Date = Date()
    
    var body: some View {
        ZStack {
            Map(){
                CircleAnnotation(centerCoordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                    .circleColor(StyleColor(.systemBlue))
                    .circleRadius(7)
                    .circleStrokeColor(StyleColor(.white))
                    .circleStrokeWidth(1)
                
            }
            .mapStyle(MapStyle(uri: StyleURI(rawValue: route.mapURL)!))
            .ignoresSafeArea()
            .onAppear {
                //load state
                latitude = UserDefaults.standard.double(forKey: "\(route.name)latitude")
                longitude = UserDefaults.standard.double(forKey: "\(route.name)longitude")
                //Mile = UserDefaults.standard.double(forKey: "\(route.name)Mile")
    //            Mile = UserDefaults.standard.double(forKey: "\(route.name)Mile")
                //startDate = UserDefaults.standard.object(forKey: "\(route.name)startDate") as! Date
                
    //            healthKitManager.queryDistanceWalked(from: self.startDate)
                viewModel.fetchWeather(lat: latitude, lon: longitude)
                
                if route.started == false{
                    self.startDate = Calendar.current.date(byAdding: .month, value: -12, to: Date())!
                    route.started = true
                }
                else{
                    print("old date")
                    startDate = UserDefaults.standard.object(forKey: "\(route.name)startDate") as! Date
                }
                print("start date: \(self.startDate)")
                
                healthKitManager.queryDistanceWalked(from: self.startDate, route: route.name)
                
    //            group.notify(queue: .main) {
    //                Mile = healthKitManager.distanceWalked
    //            }
    //            healthKitManager.queryDistanceWalked(from: self.startDate)
                
                Mile = UserDefaults.standard.double(forKey: "\(route.name)Mile")
                
                var newDistance = 0.0
                if (route.name == "Pacific Crest Trail"){
                    newDistance = healthKitManager.PCTdistanceWalked
                }
                if (route.name == "Appalachian Trail"){
                    newDistance = healthKitManager.ATdistanceWalked
                }
                if (route.name == "John Muir Trail"){
                    newDistance = healthKitManager.JMTdistanceWalked
                }
                
                if newDistance > Mile{
                    print("yeahhhhhhh")
                    Mile = newDistance
                }
                
                
                print(Mile)
                if let (long, lat) = JSONManager.getCoord(for: Mile, from: route.mileMarkerFile) {
                    self.longitude = long
                    self.latitude = lat
                }
                
                if Mile == Double(route.distance){
                    route.completed = true
                }
                
                //Mile = healthKitManager.distanceWalked
                
                //store state
                UserDefaults.standard.set(latitude, forKey: "\(route.name)latitude")
                UserDefaults.standard.set(longitude, forKey: "\(route.name)longitude")
                UserDefaults.standard.set(Mile, forKey: "\(route.name)Mile")
                UserDefaults.standard.set(startDate, forKey: "\(route.name)startDate")
                UserDefaults.standard.set(route.completed, forKey: "\(route.name)Completed")
                UserDefaults.standard.set(route.started, forKey: "\(route.name)Started")
            }
            
            
            
            
            
            
            Button {
                print("hello")
                showSheet.toggle()
            } label: {
                Image(systemName: "photo.on.rectangle")
                    .resizable()
                    .frame(width: 50, height: 50)  // Adjust the width and height as needed
                    //.foregroundColor(.red)
            }.offset(y: 340)
            .sheet(isPresented: $showSheet) {
                    SheetView(latitude: latitude, longitude: longitude) // Example coordinates for San Francisco
                }
            
            
            
            VStack(spacing: 0) {
                        if let iconURL = viewModel.weatherIconURL {
                            AsyncImage(url: iconURL) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 75, height: 75)
                        } else {
                            Text("Loading...")
                        }
                        
                        if let temperature = viewModel.temperature {
                            Text("\(temperature, specifier: "%.1f") °F")
                                .font(.title)
                                .padding(.horizontal)
                        } else {
                            Text("Loading temperature...")
                        }
                    }
                    .onAppear {
                        viewModel.fetchWeather(lat: latitude, lon: longitude) // Example coordinates
                    }.offset(x: 150, y: -360)
        }
        
        
    }
}



struct SheetView: View {
    @ObservedObject var viewModel = FlickrViewModel()
    @State private var selectedPhoto: FlickrPhoto?
    let latitude: Double
    let longitude: Double

    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        VStack {
            Text("Daily Scenary")
                    .font(.title)
                    .bold()
                    .padding()
                    .foregroundStyle(.black)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.photos) { photo in
                        if let url = URL(string: photo.imageUrl) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .onTapGesture {
                                        selectedPhoto = photo
                                    }
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 120, height: 120)
                            .cornerRadius(8)
                            .padding(5)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.fetchPhotos(latitude: latitude, longitude: longitude)
        }
        .fullScreenCover(item: $selectedPhoto) { photo in
            FullScreenImageView(photo: photo)
        }
        .background(Color("softGreen"))
    }
}




struct FullScreenImageView: View {
    let photo: FlickrPhoto
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let url = URL(string: "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_b.jpg") { // _b for larger size
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .edgesIgnoringSafeArea(.all)
                } placeholder: {
                    ProgressView()
                        .edgesIgnoringSafeArea(.all)
                }
            }

            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .clipShape(Circle())
                    .padding()
            }
        }
        .background(Color("softGreen"))
    }
}



//#Preview {
//    MapView(route: routes[1])
//}
