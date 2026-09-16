import SwiftUI

struct Icons {
    static func search(color: Color) -> some View {
        Image(systemName: "magnifyingglass")
            .foregroundColor(color)
    }
    
    static func pin(color: Color) -> some View {
        Image(systemName: "mappin")
            .foregroundColor(color)
    }
    
    static func bell(color: Color) -> some View {
        Image(systemName: "bell")
            .foregroundColor(color)
    }
    
    static func user(color: Color) -> some View {
        Image(systemName: "person")
            .foregroundColor(color)
    }
    
    static func chart(color: Color) -> some View {
        Image(systemName: "chart.bar")
            .foregroundColor(color)
    }
    
    static func layers(color: Color) -> some View {
        Image(systemName: "layers")
            .foregroundColor(color)
    }
    
    static func location(color: Color) -> some View {
        Image(systemName: "location.fill")
            .foregroundColor(color)
    }
    
    static func clock(color: Color) -> some View {
        Image(systemName: "clock")
            .foregroundColor(color)
    }
    
    static func walk(color: Color) -> some View {
        Image(systemName: "figure.walk")
            .foregroundColor(color)
    }
    
    static func check(color: Color) -> some View {
        Image(systemName: "checkmark")
            .foregroundColor(color)
    }
    
    static func arrowForward(color: Color) -> some View {
        Image(systemName: "arrow.forward")
            .foregroundColor(color)
    }
    
    static func swap(color: Color) -> some View {
        Image(systemName: "arrow.triangle.2.circlepath")
            .foregroundColor(color)
    }
}
