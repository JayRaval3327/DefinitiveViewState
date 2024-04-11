//
//  ShimmerStateView.swift
//  DefinitiveViewState
//
//  Created by Michael Long on 2/17/24.
//

import SwiftUI

struct ShimmerStateView: View {
    @StateObject var viewModel = StateViewModel()
    var body: some View {
        Group {
            StateViewBuilder(state: viewModel.state)
                .setLoadingView({
                    buildAccountList(accounts: AccountManager.mock)
                        .redacted(reason: .placeholder)
                        .shimmering()
                })
                .setErrorView({ message in
                    StandardErrorView(message: message, retry: {
                        viewModel.state = .loading
                    })
                })
                .buildContent(buildAccountList)

        }.task {
            await viewModel.load()
        }
        .navigationTitle("Accounts")
    }
    
    @ViewBuilder
    private func buildAccountList(accounts: [Account]) -> some View {
        AccountsListView(accounts: accounts)
    }
}

#Preview {
    ShimmerStateView()
}
