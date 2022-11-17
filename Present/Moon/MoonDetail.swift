//
//  MoonDetail.swift
//  Present
//
//  Created by Justin Cabral on 7/3/20.
//

import SwiftUI

struct MoonDetail: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color("backgroundColor").edgesIgnoringSafeArea(.all)
                Image("moon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .navigationTitle("How It Works")
        }
    }
}

struct MoonDetail_Previews: PreviewProvider {
    static var previews: some View {
        MoonDetail()
    }
}
