import DebugSnapshots
import Dependencies
@preconcurrency import MapKit
import simd
import SQLiteData
import SwiftUI

@DebugSnapshot
@Observable
class TripGeofenceModel {
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

  func mapTapped(coordinate: CLLocationCoordinate2D) {
    withErrorReporting {
      try database.write { db in
        try Trip
          .find(trip.id)
          .update {
            $0.geofence = $0.geofence.jsonbAppend(#bind(Location(coordinate)))
          }
          .execute(db)
      }
    }
  }

  func clearVerticesButtonTapped() {
    withErrorReporting {
      try database.write { db in
        try Trip
          .find(trip.id)
          .update {
            $0.geofence = #bind([])
          }
          .execute(db)
      }
    }
  }

  @DebugSnapshotTracked
  var tripInsideGeofence: Bool {
    tripInside(geofence: trip.geofence)
  }

  @DebugSnapshotTracked
  var tripInsideDraggingGeofence: Bool? {
    guard let draggingVertex else { return nil }
    var vertices = trip.geofence
    if vertices.indices.contains(draggingVertex.index) {
      vertices[draggingVertex.index] = draggingVertex.location
    }
    return tripInside(geofence: vertices)
  }

  private func tripInside(geofence vertices: [Location]) -> Bool {
    guard vertices.count > 2 else { return false }
    let point = unitVector(trip.location)
    var windingAngle = 0.0
    var previous = unitVector(vertices[vertices.count - 1])
    for vertex in vertices {
      let current = unitVector(vertex)
      defer { previous = current }
      windingAngle += atan2(
        simd_dot(point, simd_cross(previous, current)),
        simd_dot(previous, current) - simd_dot(previous, point) * simd_dot(current, point)
      )
    }
    return abs(windingAngle) > .pi
    func unitVector(_ location: Location) -> SIMD3<Double> {
      let latitude = location.latitude * .pi / 180
      let longitude = location.longitude * .pi / 180
      return SIMD3(
        cos(latitude) * cos(longitude),
        cos(latitude) * sin(longitude),
        sin(latitude)
      )
    }
  }

  @DebugSnapshotTracked
  var geofenceColor: Color {
    tripInsideGeofence ? .blue : .red
  }

  @DebugSnapshotTracked
  var draggingGeofenceColor: Color? {
    guard let tripInsideDraggingGeofence else { return nil }
    return tripInsideDraggingGeofence ? .blue : .red
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
            model.clearVerticesButtonTapped()
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
            .foregroundStyle(model.geofenceColor.opacity(0.2))
            .stroke(model.geofenceColor, lineWidth: 2)
        } else if coordinates.count == 2 {
          MapPolyline(coordinates: coordinates)
            .stroke(model.geofenceColor, lineWidth: 2)
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
        model.mapTapped(coordinate: coordinate)
      }
    }
  }

  @ViewBuilder
  private func dragPreview(_ proxy: MapProxy) -> some View {
    if let draggingVertex = model.draggingVertex,
      model.trip.geofence.indices.contains(draggingVertex.index),
      let point = proxy.convert(draggingVertex.location.coordinate, to: .local),
       let draggingGeofenceColor = model.draggingGeofenceColor
    {
      var vertices = model.trip.geofence
      let _ = vertices[draggingVertex.index] = draggingVertex.location
      let polygon = Path { path in
        path.addLines(
          vertices.compactMap { proxy.convert($0.coordinate, to: .local) }
        )
        path.closeSubpath()
      }
      polygon.fill(draggingGeofenceColor.opacity(0.2))
      polygon.stroke(draggingGeofenceColor, lineWidth: 2)
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
