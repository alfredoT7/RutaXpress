import SwiftUI
import MapKit

private struct TrufiPin: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let status: TrufiStatus
    let label: String
    let distance: String
}

private enum TrufiStatus {
    case available, full

    var color: Color {
        switch self {
        case .available: return AppColors.ok
        case .full: return AppColors.warn
        }
    }

    var uiColor: UIColor { UIColor(color) }

    var text: String {
        switch self {
        case .available: return "Disponible"
        case .full: return "Lleno"
        }
    }
}

private let cochabambaCenter = CLLocationCoordinate2D(latitude: -17.3895, longitude: -66.1568)
private let sheetPeek: CGFloat = 104
private let filters = ["Todas", "Línea 1", "Línea 4", "Línea 7"]

private let mockTrufis: [TrufiPin] = [
    TrufiPin(coordinate: CLLocationCoordinate2D(latitude: -17.3880, longitude: -66.1540),
             status: .available, label: "Trufi #12", distance: "180 m"),
    TrufiPin(coordinate: CLLocationCoordinate2D(latitude: -17.3925, longitude: -66.1600),
             status: .full, label: "Trufi #07", distance: "410 m"),
    TrufiPin(coordinate: CLLocationCoordinate2D(latitude: -17.3860, longitude: -66.1595),
             status: .available, label: "Trufi #21", distance: "320 m"),
]

struct HomeView: View {
    @State private var selectedFilter = "Todas"
    @State private var selectedDetent: PresentationDetent = .medium
    @State private var isSheetPresented = true

    private var isPeeked: Bool { selectedDetent == .height(sheetPeek) }

    var body: some View {
        ZStack(alignment: .top) {
            TrufiMapView(center: cochabambaCenter, trufis: mockTrufis)
                .ignoresSafeArea()

            VStack {
                Spacer()
                recenterButton
                    .opacity(isPeeked ? 1 : 0)
                    .allowsHitTesting(isPeeked)
                    .padding(.bottom, sheetPeek + AppSpacing.sm)
            }

            topControls
        }
        .sheet(isPresented: $isSheetPresented) {
            bottomSheet
                .presentationDetents([.height(sheetPeek), .medium, .large], selection: $selectedDetent)
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled()
                .modifier(MapBackgroundInteraction())
        }
        .toolbar(isPeeked ? .hidden : .visible, for: .tabBar)
    }

    private var topControls: some View {
        VStack(spacing: AppSpacing.md) {
            searchBar
            filterRow
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.top, AppSpacing.sm)
    }

    private var searchBar: some View {
        Button(action: {}) {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(AppColors.muted)
                Text("¿A dónde vas?")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.muted)
                Spacer()
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, 14)
            .background(AppColors.surface, in: Capsule())
            .appShadow(AppShadow.card)
        }
        .buttonStyle(.pressable)
    }

    private var filterRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                ForEach(filters, id: \.self) { filter in
                    let isOn = selectedFilter == filter
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                            selectedFilter = filter
                        }
                    } label: {
                        Text(filter)
                            .font(.system(size: 13, weight: isOn ? .semibold : .medium))
                            .foregroundColor(isOn ? .white : AppColors.text)
                            .padding(.horizontal, AppSpacing.md)
                            .padding(.vertical, AppSpacing.sm)
                            .background(isOn ? AppColors.primary : AppColors.surface, in: Capsule())
                            .overlay(Capsule().stroke(isOn ? Color.clear : AppColors.line, lineWidth: 1))
                            .appShadow(AppShadow.soft)
                    }
                    .buttonStyle(.pressable)
                }
            }
            .padding(.vertical, 2)
        }
    }

    private var recenterButton: some View {
        HStack {
            Spacer()
            Button(action: {}) {
                Image(systemName: "location.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundColor(AppColors.primary)
                    .frame(width: 46, height: 46)
                    .background(AppColors.surface, in: Circle())
                    .appShadow(AppShadow.card)
            }
            .buttonStyle(.pressable)
            .accessibilityLabel("Centrar mapa")
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.bottom, AppSpacing.md)
    }

    private var bottomSheet: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Ruta 4")
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.text)
                    Text("Cala Cala – Centro")
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.muted)
                }
                Spacer()
                Text("6 min")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(AppColors.secondary)
                    .padding(.horizontal, AppSpacing.sm)
                    .padding(.vertical, 5)
                    .background(AppColors.secondary.opacity(0.15), in: Capsule())
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.top, AppSpacing.md)
            .padding(.bottom, AppSpacing.md)

            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: AppSpacing.sm) {
                    ForEach(mockTrufis) { trufi in
                        trufiRow(trufi)
                    }

                    Button(action: {}) {
                        Text("Ver todas las rutas")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(AppColors.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppSpacing.md)
                    }
                    .buttonStyle(.pressable)
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, AppSpacing.lg)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(AppColors.surface)
    }

    private func trufiRow(_ trufi: TrufiPin) -> some View {
        HStack(spacing: AppSpacing.md) {
            ZStack {
                Circle().fill(trufi.status.color.opacity(0.15)).frame(width: 34, height: 34)
                Circle().fill(trufi.status.color).frame(width: 11, height: 11)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(trufi.label)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.text)
                Text(trufi.status.text)
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.muted)
            }
            Spacer()
            Text(trufi.distance)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppColors.muted)
        }
        .card(padding: AppSpacing.md, radius: AppRadius.md)
    }
}

private struct MapBackgroundInteraction: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.4, *) {
            content
                .presentationBackground(AppColors.surface)
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
        } else {
            content
        }
    }
}

private struct TrufiMapView: UIViewRepresentable {
    let center: CLLocationCoordinate2D
    let trufis: [TrufiPin]

    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.delegate = context.coordinator
        map.pointOfInterestFilter = .excludingAll
        map.showsCompass = false
        map.showsScale = false
        map.isRotateEnabled = false
        map.isPitchEnabled = false
        map.setRegion(
            MKCoordinateRegion(
                center: center,
                span: MKCoordinateSpan(latitudeDelta: 0.018, longitudeDelta: 0.018)
            ),
            animated: false
        )
        for trufi in trufis {
            map.addAnnotation(TrufiAnnotation(pin: trufi))
        }
        return map
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator() }

    final class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let trufi = annotation as? TrufiAnnotation else { return nil }
            let identifier = "trufi"
            let view = (mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView)
                ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.annotation = annotation
            view.markerTintColor = trufi.pin.status.uiColor
            view.glyphImage = UIImage(systemName: "bus.fill")
            view.displayPriority = .required
            view.canShowCallout = true
            return view
        }
    }
}

private final class TrufiAnnotation: NSObject, MKAnnotation {
    let pin: TrufiPin
    var coordinate: CLLocationCoordinate2D { pin.coordinate }
    var title: String? { pin.label }
    var subtitle: String? { "\(pin.status.text) · \(pin.distance)" }

    init(pin: TrufiPin) { self.pin = pin }
}

#Preview {
    HomeView()
}
