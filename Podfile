use_frameworks!

def shared_pods
    pod 'ReactiveSwift', '~> 3.0.0'
    pod 'SnapKit', '~> 4.0.0'
    pod 'ReactiveCocoa', '~> 7.0.1'
end

target 'TheMovieDB' do
    platform :ios, '9.0'

    shared_pods

    target 'TheMovieDBTests' do
        inherit! :search_paths
        pod 'Quick'
        pod 'Nimble'
    end
end
