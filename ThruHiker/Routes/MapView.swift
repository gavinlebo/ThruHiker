//
//  MapView.swift
//  ThruHiker
//
//  Created by Kai Linsley on 5/8/24.
//

import SwiftUI
@_spi(Experimental) import MapboxMaps
import FirebaseFirestore
//import FirebaseFirestoreSwift






struct MapView: View {
    
    
    
    @EnvironmentObject var healthKitManager: HealthKitManager
    @AppStorage("userName") private var userName: String?
    
    //@Binding var sharedState: SharedState
    @Binding var route: Route
    
    @State private var showSheet = false
    @State private var showPopover = false
    
    @StateObject var viewModel = WeatherViewModel()
    
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    @State private var Mile: Double = 0.0
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    
    @State var expectedEndDate: Date = Date()
    @State var avgDistance: Double = 0.0
    @State var stepsWalked: Double = 0.0
    
    //@State var userID: UUID = UUID()
    
    
    
    func saveToFirebase() {
        let userID = UserDefaults.standard.string(forKey: "userID")
        let db = Firestore.firestore()
        let document = db.collection("routes")
                         .document(route.name)
                         .collection("users")
                         .document(userID!)// Document ID is the name

        document.setData([
            "name": userName!,
            "miles": Mile,
            "avgDistance": avgDistance,
            "startDate": self.startDate,
            "completed": route.completed,
            "expectedFinish": self.expectedEndDate,
            "endDate": endDate
        ])
    }
    
    
    
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
                    self.startDate = Calendar.current.date(byAdding: .month, value: 0, to: Date())!
                    route.started = true
                }
                else{
                    print("old date")
                    startDate = UserDefaults.standard.object(forKey: "\(route.name)startDate") as! Date
                }
                print("start date: \(self.startDate)")
                
//                healthKitManager.queryDistanceWalked(from: self.startDate, route: route.name)
//                
//                healthKitManager.calculateDailyAverageDistance(from: self.startDate)
                
    //            group.notify(queue: .main) {
    //                Mile = healthKitManager.distanceWalked
    //            }
    //            healthKitManager.queryDistanceWalked(from: self.startDate)
                
                Mile = UserDefaults.standard.double(forKey: "\(route.name)Mile")
                
                if route.completed == false{
                    
                    var newDistance = 0.0
                    if route.name == "Pacific Crest Trail"{
                        newDistance = healthKitManager.PCTdistanceWalked
                        self.avgDistance = healthKitManager.PCTAvg
                        self.stepsWalked = healthKitManager.PCTSteps
                    }
                    if route.name == "Appalachian Trail"{
                        newDistance = healthKitManager.ATdistanceWalked
                        self.avgDistance = healthKitManager.ATAvg
                        self.stepsWalked = healthKitManager.ATSteps
                    }
                    if route.name == "John Muir Trail"{
                        newDistance = healthKitManager.JMTdistanceWalked
                        self.avgDistance = healthKitManager.JMTdAvg
                        self.stepsWalked = healthKitManager.JMTdSteps
                    }
                    if route.name == "Everest Base Camp"{
                        newDistance = healthKitManager.EverestdistanceWalked
                        self.avgDistance = healthKitManager.EverestAvg
                        self.stepsWalked = healthKitManager.EverestSteps
                    }
                    if route.name == "Continental Divide Trail"{
                        newDistance = healthKitManager.CDdistanceWalked
                        self.avgDistance = healthKitManager.CDAvg
                        self.stepsWalked = healthKitManager.CDSteps
                    }
                    if route.name == "Tour du Mont Blanc"{
                        newDistance = healthKitManager.TMBdistanceWalked
                        self.avgDistance = healthKitManager.TMBAvg
                        self.stepsWalked = healthKitManager.TMBSteps
                    }
                    //let newDistance = healthKitManager.distanceWalked
                    
                    
                    if newDistance > Mile{
                        Mile = newDistance
                    }
                    
                    if avgDistance > 0.0{
                        let daysRemaining = route.distance / avgDistance
                        
                        

                        expectedEndDate = Calendar.current.date(byAdding: .day, value: Int(daysRemaining), to: Date())!
                    }
                    
                    
                    
                }
//                var newDistance = 0.0
//                if route.name == "Pacific Crest Trail"{
//                    newDistance = healthKitManager.PCTdistanceWalked
//                    self.avgDistance = healthKitManager.PCTAvg
//                    self.stepsWalked = healthKitManager.PCTSteps
//                }
//                if route.name == "Appalachian Trail"{
//                    newDistance = healthKitManager.ATdistanceWalked
//                    self.avgDistance = healthKitManager.ATAvg
//                    self.stepsWalked = healthKitManager.ATSteps
//                }
//                if route.name == "John Muir Trail"{
//                    newDistance = healthKitManager.JMTdistanceWalked
//                    self.avgDistance = healthKitManager.JMTdAvg
//                    self.stepsWalked = healthKitManager.JMTdSteps
//                }
//                if route.name == "Everest Base Camp"{
//                    newDistance = healthKitManager.EverestdistanceWalked
//                    self.avgDistance = healthKitManager.EverestAvg
//                    self.stepsWalked = healthKitManager.EverestSteps
//                }
//                if route.name == "Continental Divide Trail"{
//                    newDistance = healthKitManager.CDdistanceWalked
//                    self.avgDistance = healthKitManager.CDAvg
//                    self.stepsWalked = healthKitManager.CDSteps
//                }
//                if route.name == "Tour du Mont Blanc"{
//                    newDistance = healthKitManager.TMBdistanceWalked
//                    self.avgDistance = healthKitManager.TMBAvg
//                    self.stepsWalked = healthKitManager.TMBSteps
//                }
//                //let newDistance = healthKitManager.distanceWalked
//                
//                
//                if newDistance > Mile{
//                    Mile = newDistance
//                }
                
                
                
                
                if Mile >= Double(route.distance){
                    route.completed = true
                    self.endDate = Calendar.current.date(byAdding: .month, value: 0, to: Date())!
                    Mile = Double(Int(route.distance))
                }
                print(Mile)
                if let (long, lat) = JSONManager.getCoord(for: Mile, from: route.mileMarkerFile) {
                    self.longitude = long
                    self.latitude = lat
                    print(long)
                    print(lat)
                }
                
                
                
//                if avgDistance > 0.0{
//                    let daysRemaining = route.distance / avgDistance
//                    
//                    
//
//                    expectedEndDate = Calendar.current.date(byAdding: .day, value: Int(daysRemaining), to: Date())!
//                }
                
                
                //Mile = healthKitManager.distanceWalked
                
                //store state
                UserDefaults.standard.set(latitude, forKey: "\(route.name)latitude")
                UserDefaults.standard.set(longitude, forKey: "\(route.name)longitude")
                UserDefaults.standard.set(Mile, forKey: "\(route.name)Mile")
                UserDefaults.standard.set(startDate, forKey: "\(route.name)startDate")
                UserDefaults.standard.set(route.completed, forKey: "\(route.name)Completed")
                UserDefaults.standard.set(route.started, forKey: "\(route.name)Started")
                
                saveToFirebase()
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
                SheetView(latitude: latitude, longitude: longitude, route: route) // Example coordinates for San Francisco
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
                                    
//                                    let formatter = DateFormatter()
//                                    formatter.dateStyle = .medium
//                                    let simpleStart = formatter.string(from: self.startDate)
//                                    let simpleEnd = formatter.string(from: self.expectedEndDate)
                                    
                                    
                                    Text("Start Date: \(startdateFormatted)")
                                    if route.completed == true {
                                        Text("Finished On: \(enddateFormatted)")
                                        Text("Miles Completed: \(Int(self.Mile))")
                                    }
                                    else{
                                        if self.Mile == 0.0{
                                            Text("Expected Finish: Not Enough Data")
                                        }
                                        else{
                                            Text("Expected Finish: \(enddateFormatted)")
                                        }
                                        
                                        Text("Miles Completed: \(Int(self.Mile))")
                                        Text("Miles Remaining: \(Int(route.distance - self.Mile))")
                                    }
                                    
                                    Text("Average Mileage: \((String(format: "%.2f", self.avgDistance)))")
                                    Text("Total Steps: \(Int(self.stepsWalked))")
//                                    Text("Expected Finish: \(self.expectedEndDate)")
                                    //Text("Miles today: ")
                                    //Text("Most miles in day: ")
                                    
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
            progressBar(progress: $Mile, totalDistance: $route.distance)
                            .frame(width: 10, height: 300)
                            .offset(x: -170)
        }
        var startdateFormatted: String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
        return formatter.string(from: self.startDate)
        }
        var enddateFormatted: String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            if route.completed == false {
                return formatter.string(from: self.expectedEndDate)
            }
            else{
                return formatter.string(from: self.expectedEndDate)
            }
        
        }
        
        
    }
}



struct IdentifiableInt: Identifiable {
    var id: Int
}

struct SheetView: View {
    @ObservedObject var viewModel = FlickrViewModel()
    @State private var selectedPhotoIndex: IdentifiableInt?
    let latitude: Double
    let longitude: Double
    let route: Route

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

struct progressBar: View {
    @Binding var progress: Double
    @Binding var totalDistance: Double

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack(alignment: .trailing) {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: geometry.size.width, height: getProg(in: geometry.size))
                    
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height-7)
            .background(Color.gray.opacity(0.9))
            .cornerRadius(5)
        }
 
    }

    private func getProg(in size: CGSize) -> CGFloat {
        return size.height * CGFloat(progress / totalDistance)
    }
}




//#Preview {
//    MapView(route: routes[1])
//}
