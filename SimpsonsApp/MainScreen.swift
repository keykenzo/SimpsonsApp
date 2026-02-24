//
//  MainScreen.swift
//  SimpsonsApp
//
//  Created by Mario Duarte on 24/02/26.
//

import SwiftUI

struct MainScreen: View {
    
    let geo: GeometryProxy
    
    var body: some View {
        ZStack {
            Image(.simpsonsSkyBackground)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: geo.size.width*2, height: geo.size.height*1.3)
                .ignoresSafeArea()
                .phaseAnimator([false, true]) { content, phase in
                    content
                        .offset(x: phase ? geo.size.width*0.6 : -geo.size.width*0.6)
                } animation: { _ in
                        .linear(duration: 30).repeatForever(autoreverses: true)
                }
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                Text("The Simpsons")
                    .font(.custom("SimpsonFont", size: 50))
                    .foregroundStyle(.yellow)
                    .shadow(color: .black, radius: 2)
                    
                
                Text("Encyclopedia")
                    .font(.custom("SimpsonFont", size: 25))
                    .foregroundStyle(.white)
                    .shadow(color: .black, radius: 2)
            }
        }
        .frame(width: geo.size.width, height: geo.size.height)
        .ignoresSafeArea()
        VStack {
            Spacer()
            Text("Tap the screen")
                .font(.custom("SimpsonFont", size: 20))
                .foregroundStyle(.white)
                .shadow(color: .black, radius: 2)
                .padding(.bottom,80)
                .phaseAnimator([0, -10, 0]) { content, offset in
                    content.offset(y: offset)
                } animation: { _ in
                        .spring(response: 0.4, dampingFraction: 0.5)
                }
        }
    }
}

#Preview {
    GeometryReader { geo in
        MainScreen(geo: geo)
            .frame(width: geo.size.width, height: geo.size.height)
    }
}
