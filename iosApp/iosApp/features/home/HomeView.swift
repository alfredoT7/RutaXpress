import SwiftUI
import MapKit

// MARK: - Modelos (mock estático)

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
        case .full:      return AppColors.warn
        }
    }

    var uiColor: UIColor { UIColor(color) }

    var text: String {
        switch self {
        case .available: return "Disponible"
        case .full:      return "Lleno"
        }
    }
}

private let cochabambaCenter = CLLocationCoordinate2D(latitude: -17.3895, longitude: -66.1568)

private let mockTrufis: [TrufiPin] = [
    TrufiPin(coordinate: CLLocationCoordinate2D(latitude: -17.3880, longitude: -66.1540),
             status: .available, label: "Trufi #12", distance: "180 m"),
    TrufiPin(coordinate: CLLocationCoordinate2D(latitude: -17.3925, longitude: -66.1600),
             status: .full, label: "Trufi #07", distance: "410 m"),
    TrufiPin(coordinate: CLLocationCoordinate2D(latitude: -17.3860, longitude: -66.1595),
             status: .available, label: "Trufi #21", distance: "320 m"),
]

private let filters = ["Todas", "Línea 1", "Línea 4", "Línea 7"]

private let sheetPeek: CGFloat = 104   // panel minimizado abajo (tab bar oculto, mapa full)

private enum SheetDetent { case peek, open, full }

private func clamp01(_ x: CGFloat) -> CGFloat { min(max(x, 0), 1) }

// MARK: - HomeView

struct HomeView: View {
    /// Reporta 0 (tab bar visible) → 1 (tab bar oculto). 1 = panel minimizado abajo.
    @Binding var sheetProgress: CGFloat

    @State private var selectedFilter = "Todas"
    @State private var detent: SheetDetent = .open
    @State private var dragY: CGFloat = 0

    init(sheetProgress: Binding<CGFloat> = .constant(0)) {
        self._sheetProgress = sheetProgress
    }

    var body: some View {
        GeometryReader { geo in
            let H = geo.size.height
            let openH = max(H * 0.5, sheetPeek + 1)
            let fullH = max(H * 0.9, openH + 1)

            let baseH = height(for: detent, open: openH, full: fullH)
            let currentH = min(max(baseH - dragY, sheetPeek), fullH)
            // offset hacia abajo dentro de un sheet de altura fullH → parte visible = currentH
            let offsetY = fullH - currentH
            // ocultar tab bar sólo al bajar por debajo de "open" hacia "peek"
            let hide = clamp01((openH - currentH) / (openH - sheetPeek))

            ZStack(alignment: .top) {
                // Mapa limpio (sin POIs de Apple)
                TrufiMapView(center: cochabambaCenter, trufis: mockTrufis)
                    .ignoresSafeArea()

                // Botón recenter, visible cuando el panel está abajo (mapa full)
                VStack {
                    Spacer()
                    recenterButton
                        .opacity(Double(hide))
                        .padding(.bottom, sheetPeek + AppSpacing.sm)
                }

                topControls

                // Bottom sheet flush al fondo; sólo se mueve con offset (sin reflow)
                bottomSheet(openH: openH, fullH: fullH)
                    .frame(height: fullH)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y: offsetY)
            }
        }
    }

    private func height(for d: SheetDetent, open: CGFloat, full: CGFloat) -> CGFloat {
        switch d {
        case .peek: return sheetPeek
        case .open: return open
        case .full: return full
        }
    }

    // MARK: Controles superiores

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
                            .overlay(
                                Capsule().stroke(isOn ? Color.clear : AppColors.line, lineWidth: 1)
                            )
                            .appShadow(AppShadow.soft)
                    }
                    .buttonStyle(.pressable)
                }
            }
            .padding(.vertical, 2)
        }
    }

    // MARK: Botón recenter

    private var recenterButton: some View {
        HStack {
            Spacer()
            Button(action: {}) {
                Image(systemName: "location.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundColor(AppColors.primary)
                    .frame(width: 46, height: 46, alignment: .center)
                    .background(AppColors.surface, in: Circle())
                    .appShadow(AppShadow.card)
            }
            .buttonStyle(.pressable)
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.bottom, AppSpacing.md)
    }

    // MARK: Bottom sheet fluido (offset, no reflow)

    private func sheetDrag(openH: CGFloat, fullH: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 4)
            .onChanged { value in
                dragY = value.translation.height
                let baseH = height(for: detent, open: openH, full: fullH)
                let currentH = min(max(baseH - dragY, sheetPeek), fullH)
                sheetProgress = clamp01((openH - currentH) / (openH - sheetPeek))
            }
            .onEnded { value in
                let baseH = height(for: detent, open: openH, full: fullH)
                let predictedH = min(max(baseH - value.predictedEndTranslation.height, sheetPeek), fullH)
                let target: SheetDetent =
                    predictedH < (sheetPeek + openH) / 2 ? .peek :
                    predictedH < (openH + fullH) / 2 ? .open : .full
                withAnimation(.interactiveSpring(response: 0.42, dampingFraction: 0.86)) {
                    detent = target
                    dragY = 0
                    sheetProgress = target == .peek ? 1 : 0
                }
            }
    }

    private func bottomSheet(openH: CGFloat, fullH: CGFloat) -> some View {
        VStack(spacing: 0) {
            // Zona de arrastre: grabber + cabecera de ruta
            VStack(spacing: 0) {
                Capsule()
                    .fill(AppColors.faint)
                    .frame(width: 40, height: 5)
                    .padding(.top, AppSpacing.md)
                    .padding(.bottom, AppSpacing.lg)
                    .frame(maxWidth: .infinity)

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
                .padding(.bottom, AppSpacing.md)
            }
            .contentShape(Rectangle())
            .gesture(sheetDrag(openH: openH, fullH: fullH))

            ScrollView(showsIndicators: false) {
                VStack(spacing: AppSpacing.sm) {
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
                .padding(.top, AppSpacing.xs)
                .padding(.bottom, tabBarHeight + AppSpacing.md)
            }
            .scrollDisabled(detent == .peek)
        }
        .frame(maxWidth: .infinity)
        .background(
            UnevenRoundedRectangle(
                topLeadingRadius: 24, bottomLeadingRadius: 0,
                bottomTrailingRadius: 0, topTrailingRadius: 24,
                style: .continuous
            )
            .fill(AppColors.surface)
        )
        .appShadow(AppShadow.floating)
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

// MARK: - MKMapView limpio (sin POIs) con marcadores de trufi

private struct TrufiMapView: UIViewRepresentable {
    let center: CLLocationCoordinate2D
    let trufis: [TrufiPin]

    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.delegate = context.coordinator
        map.pointOfInterestFilter = .excludingAll   // oculta POIs de Apple → mapa limpio
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
            let ann = TrufiAnnotation(pin: trufi)
            map.addAnnotation(ann)
        }
        return map
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator() }

    final class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let trufi = annotation as? TrufiAnnotation else { return nil }
            let id = "trufi"
            let view = (mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView)
                ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: id)
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
