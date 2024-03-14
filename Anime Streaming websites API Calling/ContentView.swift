//
//  ContentView.swift
//  Anime Streaming websites API Calling
//
//  Created by Betzy Moreno on 3/8/24.
//

import SwiftUI

struct ContentView: View {
    @State private var  entries = [Entry]()
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            List(entries) { entry in
                Link(destination: URL(string: entry.link)!) {
                    Text(entry.name)
                }
            }
            .navigationTitle("Anime Charaters")
        }
        .task {
            await getCategories()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Loading Error"), message: Text("There was a problem loading the anime charaters"), dismissButton: .default(Text("ok")))
        }
    }
    
    func getCategories() async {
        let query = "http://api.jikan.moe/v4/anime"
        if let url = URL(string: query) {
            if let (data, _) = try? await URLSession.shared.data(from: url) {
                if let decodedResponse = try? JSONDecoder().decode(Entries.self, from: data) {
                    entries = decodedResponse.response
                    return
                }
            }
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Entry: Identifiable, Codable {
    var id = UUID()
    var name: String
    var link: String
    
    
    enum CodingKeys: String, CodingKey {
        case name = "title"
        case link = "url"
    }
}
struct Entries: Codable {
    var response: [Entry]
    
    enum CodingKeys: String, CodingKey {
        case response = "data"
    }
}
