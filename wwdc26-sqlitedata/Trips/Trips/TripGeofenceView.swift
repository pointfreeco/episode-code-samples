import Dependencies
@preconcurrency import MapKit
import SQLiteData
import SwiftUI

@Observable class TripGeofenceModel {
  @ObservationIgnored @FetchOne
  var trip: Trip
  var draggingVertex: DraggingVertex?

  @ObservationIgnored @Dependency(\.defaultDatabase) var database

  init(trip: Trip) {
    _trip = FetchOne(wrappedValue: trip, Trip.find(trip.id))
  }

  func droppedVertex() {
    defer { draggingVertex = nil }
    guard let draggingVertex
    else { return }

    withErrorReporting {
      try database.write { db in
        try Trip
          .find(trip.id)
          .update {
            $0.geofence = $0.geofence
              .jsonbSet(
                \.[draggingVertex.index].latitude,
                draggingVertex.location.latitude
              )
              .jsonbSet(
                \.[draggingVertex.index].longitude,
                draggingVertex.location.longitude
              )
          }
          .execute(db)
      }
    }
  }
}

struct TripGeofenceView: View {
  @Bindable var model: TripGeofenceModel

  var body: some View {
    VStack(spacing: 0) {
      GeofenceMap(model: model)
        .frame(minHeight: 280)

      vertices
    }
    .navigationTitle(model.trip.displayName)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button("Clear", systemImage: "trash", role: .destructive) {
          Task {
            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Clear vertices button tapped@*//*@END_MENU_TOKEN@*/
          }
        }
      }
    }
  }

  private var vertices: some View {
    List {
      Section {
        if model.trip.geofence.isEmpty {
          Text("Tap the map to drop the first vertex.")
            .foregroundStyle(.secondary)
        }
        ForEach(Array(activeGeofence.enumerated()), id: \.offset) {
          index,
          vertex in
          LabeledContent {
            Text(
              "\(vertex.latitude, format: coordinateFormatStyle), \(vertex.longitude, format: coordinateFormatStyle)"
            )
            .font(.caption.monospacedDigit())
            .foregroundStyle(.secondary)
          } label: {
            Label(
              "Vertex \(index + 1)",
              systemImage: "\(index + 1).circle.fill"
            )
          }
          .contentShape(.rect)
          .swipeActions {
            Button("Delete", systemImage: "trash", role: .destructive) {
              /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Delete vertex button tapped@*//*@END_MENU_TOKEN@*/
            }
          }
        }
      } header: {
        Text("Vertices")
      }
    }
  }

  private var activeGeofence: [Location] {
    guard
      let draggingVertex = model.draggingVertex,
      model.trip.geofence.indices.contains(draggingVertex.index)
    else { return model.trip.geofence }
    var vertices = model.trip.geofence
    vertices[draggingVertex.index] = draggingVertex.location
    return vertices
  }
}

private struct GeofenceMap: View {
  @Bindable var model: TripGeofenceModel

  var body: some View {
    MapReader { proxy in
      Map(
        initialPosition: .region(initialRegion),
        interactionModes: model.draggingVertex == nil ? .all : []
      ) {
        let coordinates = model.trip.geofence.map(\.coordinate)
        if coordinates.count > 2 {
          MapPolygon(coordinates: coordinates)
            .foregroundStyle(.blue.opacity(0.2))
            .stroke(.blue, lineWidth: 2)
        } else if coordinates.count == 2 {
          MapPolyline(coordinates: coordinates)
            .stroke(.blue, lineWidth: 2)
        }

        Marker(
          model.trip.displayDestination,
          coordinate: model.trip.location.coordinate
        )
        .tint(.secondary)

        ForEach(Array(model.trip.geofence.enumerated()), id: \.offset) {
          index,
          vertex in
          Annotation("Vertex \(index + 1)", coordinate: vertex.coordinate) {
            VertexHandle(number: index + 1, isDragging: false)
              .opacity(model.draggingVertex?.index == index ? 0 : 1)
              .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .global)
                  .onChanged { gesture in
                    guard
                      let coordinate = proxy.convert(
                        gesture.location,
                        from: .global
                      )
                    else { return }
                    model.draggingVertex = DraggingVertex(
                      index: index,
                      location: Location(coordinate)
                    )
                  }
                  .onEnded { gesture in
                    model.droppedVertex()
                  }
              )
          }
        }
        .annotationTitles(.hidden)
      }
      .overlay {
        dragPreview(proxy)
          .allowsHitTesting(false)
      }
      .onTapGesture(coordinateSpace: .global) { point in
        guard let coordinate = proxy.convert(point, from: .global)
        else { return }
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=User tapped map@*//*@END_MENU_TOKEN@*/
        _ = coordinate
      }
    }
  }

  @ViewBuilder
  private func dragPreview(_ proxy: MapProxy) -> some View {
    if let draggingVertex = model.draggingVertex,
      model.trip.geofence.indices.contains(draggingVertex.index),
      let point = proxy.convert(draggingVertex.location.coordinate, to: .local)
    {
      var vertices = model.trip.geofence
      let _ = vertices[draggingVertex.index] = draggingVertex.location
      let polygon = Path { path in
        path.addLines(
          vertices.compactMap { proxy.convert($0.coordinate, to: .local) }
        )
        path.closeSubpath()
      }
      polygon.fill(.blue.opacity(0.2))
      polygon.stroke(.blue, lineWidth: 2)
      VertexHandle(number: draggingVertex.index + 1, isDragging: true)
        .position(point)
    }
  }

  private var initialRegion: MKCoordinateRegion {
    guard !model.trip.geofence.isEmpty else {
      return MKCoordinateRegion(
        center: model.trip.location.coordinate,
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
      )
    }
    let latitudes =
      model.trip.geofence.map(\.latitude) + [model.trip.location.latitude]
    let longitudes =
      model.trip.geofence.map(\.longitude) + [model.trip.location.longitude]
    let center = CLLocationCoordinate2D(
      latitude: (latitudes.min()! + latitudes.max()!) / 2,
      longitude: (longitudes.min()! + longitudes.max()!) / 2
    )
    return MKCoordinateRegion(
      center: center,
      span: MKCoordinateSpan(
        latitudeDelta: max((latitudes.max()! - latitudes.min()!) * 2, 0.02),
        longitudeDelta: max((longitudes.max()! - longitudes.min()!) * 2, 0.02)
      )
    )
  }
}

struct DraggingVertex: Equatable {
  let index: Int
  let location: Location
}

private struct VertexHandle: View {
  let number: Int
  let isDragging: Bool

  var body: some View {
    Text("\(number)")
      .font(.caption.bold().monospacedDigit())
      .foregroundStyle(.white)
      .frame(width: 28, height: 28)
      .background(.blue, in: .circle)
      .overlay(Circle().stroke(.white, lineWidth: 2))
      .shadow(radius: isDragging ? 8 : 2)
      .scaleEffect(isDragging ? 1.4 : 1)
      .animation(.snappy, value: isDragging)
      .contentShape(.circle)
  }
}

private var coordinateFormatStyle: FloatingPointFormatStyle<Double> {
  .number.precision(.fractionLength(4))
}

#Preview {
  let trip = prepareDependencies {
    try! $0.bootstrapDatabase()
    try! $0.defaultDatabase.seedDatabase()
    return try! $0.defaultDatabase.read { db in
      try Trip.offset(4).fetchOne(db)!
    }
  }

  NavigationStack {
    TripGeofenceView(model: TripGeofenceModel(trip: trip))
  }
}
