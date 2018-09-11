use_frameworks!

def shared_pods
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
