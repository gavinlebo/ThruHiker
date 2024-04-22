
import SwiftUI
import MapKit

struct RouteCardView: View {
    let route: Route
    
    var body: some View {
        VStack(spacing: 10) {
            MapView()
                .frame(height: 150)
                .cornerRadius(10)

            VStack(spacing: 5) {
                Text(route.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)
                    .foregroundColor(.white)
                
                HStack {
                    Text("Distance: \(route.distance) miles")
                    Spacer()
                    Text("Time: \(route.time)")
                }
                .font(.subheadline)
                .foregroundColor(.white)
            }
            .padding()
            .background(Color("buttonBackground"))
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.bottom, 10)
            
            HStack(spacing: 20) {
                Button(action: {
                    // card flip to more information page
                }) {
                    Text("More info")
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                Button(action: {
                    // navigation button to start route page
                }) {
                    Text("Start Route")
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.orange)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color("routeBackground"))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct MapView: View {
    var body: some View {
        Map()
    }
}

struct RouteCardView_Previews: PreviewProvider {
    static var previews: some View {
        RouteCardView(route: routes[1])
            .previewLayout(.sizeThatFits)
    }
}
