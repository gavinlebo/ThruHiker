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
    @State private var showPopover = false
    
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
            .ornamentOptions(OrnamentOptions(
                scaleBar: ScaleBarViewOptions(visibility: .adaptive),
                compass: CompassViewOptions(position: .bottomLeading, visibility: .hidden)
                ))

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
            
            
            
            
            
            
//            Button {
//                showSheet.toggle()
//            } label: {
//                Image(systemName: "photo.fill.on.rectangle.fill")
//                    .resizable()
//                    .backgroundStyle(.white)
//                    .frame(width: 70, height: 70)  // Adjust the width and height as needed
//                    //.foregroundColor(.red)
//            }.offset(y: 320)
//            .sheet(isPresented: $showSheet) {
//                SheetView(latitude: latitude, longitude: longitude) // Example coordinates for San Francisco
//            }
            Button {
                showSheet.toggle()
            } label: {
                Image(systemName: "photo.fill.on.rectangle.fill")
                    .resizable()
                    .foregroundStyle(.blue)
                    .frame(width: 70, height: 70) // Adjust the frame size to make it smaller
                    .padding(10) // Add padding to create space around the image
            }
            
            .offset(y: 320)
            .sheet(isPresented: $showSheet) {
                SheetView(latitude: latitude, longitude: longitude) // Example coordinates for San Francisco
            }
            
            
            
            Button {
                showPopover.toggle()
            } label: {
                Image(systemName: "chart.bar.xaxis")
                    .resizable()
                    .foregroundStyle(.blue)
                    .frame(width: 50, height: 50) // Adjust the frame size to make it smaller
                    .padding(10) // Add padding to create space around the image
            }
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(.white)
                    .frame(width: 70, height: 70) // Set the frame size for the background
            )
            .offset(x: 150, y: 320)
            
            if showPopover {
                            Color.black.opacity(0.4) // Optional: dim background
                                .edgesIgnoringSafeArea(.all)
                                .onTapGesture {
                                    showPopover = false
                                }

                            VStack {
                                
                                VStack {
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            showPopover = false
                                        }) {
                                            Image(systemName: "xmark")
                                                .foregroundColor(.white)
                                                //.padding()
                                                .frame(width: 30, height: 30)
                                                .background(Color.red)
                                                .clipShape(Circle())
                                        }
                                    }
                                    //.padding([.top, .trailing])

                                    Text("Statistics")
                                        .font(.title)
                                        .bold()
                                        .padding()
                                    Text("Start Date: \(self.startDate)")
                                    Text("Miles Completed: \(Int(self.Mile))")
                                    Text("Miles Remaining: \(Int(route.distance - self.Mile))")
                                    Text("Expected Finish: ")
                                    Text("Miles today: ")
                                    Text("Most miles in day: ")
                                    
                                    Spacer()
                                }
                                .padding()
                                .frame(width: 300, height: 350)
                                .background(.softGreen)
                                .cornerRadius(15)
                                .shadow(radius: 10)
                            }
                            .transition(.scale)
                        }
//            if showPopover {
//                            Color.black.opacity(0.4) // Optional: dim background
//                                .edgesIgnoringSafeArea(.all)
//                                .onTapGesture {
//                                    showPopover = false
//                                }
//
//                            VStack {
//                                Text("Statistics")
//                                    .font(.title)
//                                    .bold()
//                                    .padding()
//                                Text("Start Date: \(self.startDate)")
//                                Text("Miles Completed: \(Int(self.Mile))")
//                                Text("Miles Remaining: \(route.distance - Int(self.Mile))")
//                                
//                                
//                                //More statistics here
//                                
//                                Button("Close") {
//                                    showPopover = false
//                                }
//                            }
//                            .padding()
//                            .frame(width: 300, height: 300)
//                            .background(.softGreen)
//                            .cornerRadius(15)
//                            .shadow(radius: 10)
//                            .transition(.scale)
//                        }
                
            
            
            
            
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
                    }.offset(x: 140, y: -360)
        }
        
        
    }
}



//struct SheetView: View {
//    @ObservedObject var viewModel = FlickrViewModel()
//    @State private var selectedPhoto: FlickrPhoto?
//    let latitude: Double
//    let longitude: Double
//
//    let columns = [
//        GridItem(.flexible(), spacing: 20),
//        GridItem(.flexible(), spacing: 20),
//        GridItem(.flexible(), spacing: 20)
//    ]
//    
//    var body: some View {
//        VStack {
//            Text("Daily Scenary")
//                    .font(.title)
//                    .bold()
//                    .padding()
//                    .foregroundStyle(.black)
//            
//            ScrollView {
//                LazyVGrid(columns: columns, spacing: 20) {
//                    ForEach(viewModel.photos) { photo in
//                        if let url = URL(string: photo.imageUrl) {
//                            AsyncImage(url: url) { image in
//                                image
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .onTapGesture {
//                                        selectedPhoto = photo
//                                    }
//                            } placeholder: {
//                                ProgressView()
//                            }
//                            .frame(width: 120, height: 120)
//                            .cornerRadius(8)
//                            .padding(5)
//                        }
//                    }
//                }
//                .padding()
//            }
//        }
//        .onAppear {
//            viewModel.fetchPhotos(latitude: latitude, longitude: longitude)
//        }
//        .fullScreenCover(item: $selectedPhoto) { photo in
//            FullScreenImageView(photo: photo)
//        }
//        .background(Color("softGreen"))
//    }
//}

struct IdentifiableInt: Identifiable {
    var id: Int
}

struct SheetView: View {
    @ObservedObject var viewModel = FlickrViewModel()
    @State private var selectedPhotoIndex: IdentifiableInt?
    let latitude: Double
    let longitude: Double

    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        VStack {
            Text("Daily Scenary")
                .font(.title)
                .bold()
                .padding()
                .foregroundStyle(.black)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(viewModel.photos.indices, id: \.self) { index in
                        if let url = URL(string: viewModel.photos[index].imageUrl) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .onTapGesture {
                                        selectedPhotoIndex = IdentifiableInt(id: index)
                                    }
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 170, height: 170)
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
        .fullScreenCover(item: $selectedPhotoIndex) { identifiableIndex in
            FullScreenImageView(viewModel: viewModel, selectedPhotoIndex: identifiableIndex.id)
        }
        .background(Color("softGreen"))
    }
}





//
//struct FullScreenImageView: View {
//    @ObservedObject var viewModel: FlickrViewModel
//    @State private var selectedPhotoIndex: Int
//    @Environment(\.presentationMode) var presentationMode
//
//    @State private var scale: CGFloat = 1.0
//    @State private var lastScale: CGFloat = 1.0
//
//    init(viewModel: FlickrViewModel, selectedPhotoIndex: Int) {
//        self.viewModel = viewModel
//        self._selectedPhotoIndex = State(initialValue: selectedPhotoIndex)
//    }
//
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                if let url = URL(string: "https://farm\(viewModel.photos[selectedPhotoIndex].farm).staticflickr.com/\(viewModel.photos[selectedPhotoIndex].server)/\(viewModel.photos[selectedPhotoIndex].id)_\(viewModel.photos[selectedPhotoIndex].secret)_b.jpg") {
//                    AsyncImage(url: url) { image in
//                        image
//                            .resizable()
//                            .scaledToFit()
//                            .scaleEffect(scale)
//                            .gesture(
//                                MagnificationGesture()
//                                    .onChanged { value in
//                                        scale = lastScale * value
//                                        if scale < 1.0{
//                                            scale = 1.0
//                                        }
//                                    }
//                                    .onEnded { _ in
//                                        lastScale = scale
//                                    }
//                            )
//                            
//                            .edgesIgnoringSafeArea(.all)
//                    } placeholder: {
//                        ProgressView()
//                            .edgesIgnoringSafeArea(.all)
//                    }
//                }
//
//                VStack {
//                    HStack {
//                        Spacer()
//
//                        Button(action: {
//                            presentationMode.wrappedValue.dismiss()
//                        }) {
//                            Image(systemName: "xmark")
//                                .foregroundColor(.white)
//                                .padding()
//                                .frame(width: 30, height: 30)
//                                .background(Color.red)
//                                .clipShape(Circle())
//                        }
//                    }
//
//                    Spacer()
//                }
//
//                HStack {
//                    Button(action: {
//                        selectedPhotoIndex = max(selectedPhotoIndex - 1, 0)
//                        resetScale()
//                    }) {
//                        Image(systemName: "chevron.left.circle.fill")
//                            .font(.largeTitle)
//                            .foregroundStyle(Color("lightBrown"))
//                            //.padding()
////                            .background(Color.black.opacity(0.6))
////                            .clipShape(Circle())
//                            //.padding()
//                    }
//                    .disabled(selectedPhotoIndex == 0)
//
//                    Spacer()
//
//                    Button(action: {
//                        selectedPhotoIndex = min(selectedPhotoIndex + 1, viewModel.photos.count - 1)
//                        resetScale()
//                    }) {
//                        Image(systemName: "chevron.right.circle.fill")
//                            .font(.largeTitle)
//                            .foregroundStyle(Color("lightBrown"))
//                            //.padding()
////                            .background(Color.black.opacity(0.6))
////                            .clipShape(Circle())
//                            //.padding()
//                    }
//                    .disabled(selectedPhotoIndex == viewModel.photos.count - 1)
//                }
//                .padding(.horizontal)
//            }
//        }
//    }
//
//    private func resetScale() {
//        scale = 1.0
//        lastScale = 1.0
//    }
//}


struct FullScreenImageView: View {
    @ObservedObject var viewModel: FlickrViewModel
    @State private var selectedPhotoIndex: Int
    @Environment(\.presentationMode) var presentationMode

    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0

    init(viewModel: FlickrViewModel, selectedPhotoIndex: Int) {
        self.viewModel = viewModel
        self._selectedPhotoIndex = State(initialValue: selectedPhotoIndex)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer()

                    if let url = URL(string: "https://farm\(viewModel.photos[selectedPhotoIndex].farm).staticflickr.com/\(viewModel.photos[selectedPhotoIndex].server)/\(viewModel.photos[selectedPhotoIndex].id)_\(viewModel.photos[selectedPhotoIndex].secret)_b.jpg") {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .scaleEffect(scale)
                                .gesture(
                                    MagnificationGesture()
                                        .onChanged { value in
                                            scale = lastScale * value
                                            if scale < 1.0{
                                                scale = 1.0
                                            }
                                        }
                                        .onEnded { _ in
                                            lastScale = scale
                                        }
                                )
                                .overlay(
                                    HStack {
                                        Button(action: {
                                            selectedPhotoIndex = max(selectedPhotoIndex - 1, 0)
                                            resetScale()
                                        }) {
                                            Image(systemName: "chevron.left.circle.fill")
                                                .font(.largeTitle)
                                                .foregroundStyle(Color("lightBrown"))
                                        }
                                        .disabled(selectedPhotoIndex == 0)

                                        Spacer()

                                        Button(action: {
                                            selectedPhotoIndex = min(selectedPhotoIndex + 1, viewModel.photos.count - 1)
                                            resetScale()
                                        }) {
                                            Image(systemName: "chevron.right.circle.fill")
                                                .font(.largeTitle)
                                                .foregroundStyle(Color("lightBrown"))
                                        }
                                        .disabled(selectedPhotoIndex == viewModel.photos.count - 1)
                                    }
                                    .padding(.horizontal),
                                    alignment: .center
                                )
                                .overlay(
                                    VStack {
                                        HStack {
                                            Spacer()

                                            Button(action: {
                                                presentationMode.wrappedValue.dismiss()
                                            }) {
                                                Image(systemName: "xmark")
                                                    .foregroundColor(.white)
                                                    .padding()
                                                    .frame(width: 30, height: 30)
                                                    .background(Color.red)
                                                    .clipShape(Circle())
                                            }
                                        }
                                        Spacer()
                                    },
                                    alignment: .topTrailing
                                )
                        } placeholder: {
                            ProgressView()
                                .edgesIgnoringSafeArea(.all)
                        }
                    }

                    Spacer()
                }
            }
        }
    }

    private func resetScale() {
        scale = 1.0
        lastScale = 1.0
    }
}






//#Preview {
//    MapView(route: routes[1])
//}
