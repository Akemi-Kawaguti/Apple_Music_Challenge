import SwiftUI

struct SheetSearch: View {
    let imagem: String
    let titulo: String
    let amigo: String
    
    @State private var audioManager = SpotifyManager()
    @State private var searchQuery: String = ""
    @State private var searchResults: [SpotifyManager.SpotifySong] = []
    @State private var isSearching: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                HStack {
                    VStack {
                        NowPlaying(imageSize: 45, showArtworkOnly: true)
                            .frame(maxWidth: 100, alignment: .center)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(titulo)
                            .font(.title3)
                            .bold()
                        
                        Text(amigo)
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                    }
                    .padding(.vertical, 15)
                    
                    Spacer()
                }
                .background(.gray.opacity(0.2))
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 5,
                        bottomLeadingRadius: 15,
                        bottomTrailingRadius: 5,
                        topTrailingRadius: 15
                    )
                )
                .padding(.horizontal, 20)
                .padding(.top, 10)

                List(searchResults) { song in
                    Button {

                        audioManager.addToQueue(trackURI: "spotify:track:\(song.id)")
                    } label: {
                        HStack(spacing: 12) {
                            // Capa do Álbum
                            AsyncImage(url: URL(string: song.albumArtworkURL ?? "")) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } else {
                                    Color.gray.opacity(0.3)
                                }
                            }
                            .frame(width: 50, height: 50)
                            .cornerRadius(6)
                            
                            // Título e Artista
                            VStack(alignment: .leading, spacing: 4) {
                                Text(song.title)
                                    .font(.headline)
                                    .lineLimit(1)
                                
                                Text(song.artistName)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "plus.circle")
                                .font(.title2)
                                .foregroundStyle(.green)
                        }
                    }
                }
                .listStyle(.plain)
                .searchable(text: $searchQuery, prompt: "Buscar músicas no Spotify...")
                .onChange(of: searchQuery) { oldValue, newValue in
                    // Realiza a busca sempre que o texto mudar
                    Task {
                        if newValue.isEmpty {
                            searchResults = []
                        } else {
                            // Pequeno delay opcional para evitar requisições excessivas a cada letra digitada
                            try? await Task.sleep(nanoseconds: 300_000_000)
                            guard newValue == searchQuery else { return }
                            
                            searchResults = await audioManager.searchTracks(query: newValue)
                        }
                    }
                }
            }
            .navigationTitle("Adicionar à Fila")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SheetSearch(imagem: "Musica_1", titulo: "Sessão com Amigo", amigo: "João")
}
