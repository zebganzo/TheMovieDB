use_frameworks!

def shared_pods
end

target 'TheMovieDB' do
    platform :ios, '9.0'

    shared_pods

    target 'TheMovieDBTests' do
        inherit! :search_paths
        pod 'Quick', '~> 1.2.0'
        pod 'Nimble', '~> 7.0.1'
    end
end
