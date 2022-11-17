//
//  SeasonDetail.swift
//  Present
//
//  Created by Justin Cabral on 7/3/20.
//

import SwiftUI

struct SeasonDetail: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color("backgroundColor").edgesIgnoringSafeArea(.all)
                Image("year")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .navigationTitle("How It Works")
        }
    }
}

struct SeasonDetail_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SeasonDetail()
            SeasonDetail()
                .previewDevice("iPhone 11 Pro")
            SeasonDetail()
                .previewDevice("iPhone 11")
            SeasonDetail()
                .previewDevice("iPhone 8 Plus")
            SeasonDetail()
                .previewDevice("iPhone SE (2nd generation)")
        }
    }
}
