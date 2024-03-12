//
//  ContentView.swift
//  Anime Streaming websites API Calling
//
//  Created by Betzy Moreno on 3/8/24.
//

import SwiftUI

struct ContentView: View {
    @State private var  entries = [Entry]()
    var body: some View {
        NavigationView {
            List(entries) { entry in
                NavigationLink {
                    VStack {
                        Text(entry.anime)
                            .font(.title)
                            .padding()
                        Text(entry.shows)
                            .font(.headline)
                            .padding()
                        Text("\"\(entry.websites)\"")
                            .padding()
                        Spacer()
                    }
                } label: {
                    VStack(alignment: .leading) {
                        Text(entry.shows)
                            .fontWeight(.bold)
                        Text(entry.anime)
                    }
                }
            }
            .navigationTitle("Anime Streaming Websites")
            .toolbar {
                Button {
                    Task {
                        await loadData()
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
        .task {
            await loadData()
        }
    }
    func loadData() async {
        if let url = URL(string: "https://kitsu.io/api/edge/anime") {
            if let (data, _) = try? await URLSession.shared.data(from: url) {
                if let decodedResponse = try? JSONDecoder().decode([Entry].self, from: data) {
                    entries = decodedResponse
                }
            }
           }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
    struct Entry: Identifiable, Codable {
        var id = UUID()
        var anime: String
        var shows: String
        var websites: String
        
        enum CodingKey: String {
            case anime
            case shows
            case websites
        }
    }
