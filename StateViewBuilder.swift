//
//  StateViewBuilder.swift
//  DefinitiveViewState
//
//  Created by Jay Raval on 2024-04-11.
//

import Foundation
import SwiftUI
import Combine

final class StateViewBuilder<Result> {
    
    private let state: LoadingViewState<Result>
    private var loading: (() -> AnyView)?
    private var errored: (() -> AnyView)?
    
    init(state: LoadingViewState<Result>) {
        self.state = state
    }
    
    @ViewBuilder
    func buildContent<Content: View>(@ViewBuilder _ content: (Result) -> Content) -> some View {
        self.buildDefaultView(content)
    }
    
    @ViewBuilder
    private func buildDefaultView<Content: View>(@ViewBuilder _ content: (Result) -> Content) -> some View {
        switch self.state {
        case .loading:
            if let loadingView = self.loading {
                loadingView()
            } else {
                StandardProgressView()
            }
        case .loaded(let data):
            content(data)
        case .empty(let message):
            StandardEmptyView(message: message)
        case .error(let message):
            if let errorView = self.errored {
                errorView()
            } else {
                StandardEmptyView(message: message)
            }
        }
    }
    
    func setLoadingView<Loading: View>(@ViewBuilder _ loading: @escaping () -> Loading) -> Self {
        self.loading = { AnyView(loading()) }
        return self
    }
    
    func setErrorView<ErrorView: View>(@ViewBuilder _ errorView: @escaping (String) -> ErrorView) -> Self {
        self.errored = {
            if case .error(let errorMessage) = self.state {
                return AnyView(errorView(errorMessage))
            } else {
                return AnyView(EmptyView())
            }
        }
        return self
    }
}
