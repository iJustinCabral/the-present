//
//  TodayDetail.swift
//  Present
//
//  Created by Justin Cabral on 7/3/20.
//

import SwiftUI

struct TodayDetail: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color("backgroundColor").edgesIgnoringSafeArea(.all)
                Image("day")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .navigationTitle("How It Works")
        }
    }
}

struct TodayDetail_Previews: PreviewProvider {
    static var previews: some View {
        TodayDetail()
    }
}
